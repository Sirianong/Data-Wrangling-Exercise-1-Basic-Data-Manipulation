## getting around with import column error by create vector name and replace 

header_refine <- c("company","product","address","city","country","name")
print(header_refine)
colnames(refine) <- header_refine
View(refine)
refine_1 <- refine[-1,]

## 1. clean up brand names
refine_1$company <- tolower(refine_1$company)
refine_1 <- refine_1 %>% mutate(company_new = ifelse(company == "ak zo"| 
                                                       company == "akz0"|company == "akzo","akzo",
                                                     ifelse(company == "fillips"|company == "phillips"|company == "phillps"|
                                                              company == "phllips"|company=="philips"|company=="phlips",
                                                            "philips",ifelse(company=="unilver"|company =="unilever", "unilever","van houten"))))

refine_1$company <- refine_1$company_new

## 2. separate product code and number
library(dplyr)
refine_1 <- refine_1 %>% mutate(product_code = substr(product,1,1) )
refine_1 <- refine_1 %>% mutate(product_number = substr(product,3,4) )
View(refine_1)


## 3. Add product categories
refine_2 <- refine_1 %>% mutate(product_categories = ifelse(product_code == "p","Smartphone", 
                      ifelse(product_code == "v", "TV", ifelse(product_code == "x"
                             ,"Labtop","Tablet"))))

View(refine_2)

## 4. Add Full address
refine_3 <- refine_2 %>% mutate(full_address = paste(address,city,country))


View(refine_3)

## 5. create dummy
## Add four binary (1 or 0) columns for company: 
## company_philips, company_akzo, company_van_houten and company_unilever
## Add four binary (1 or 0) columns for product category: 
## product_smartphone, product_tv, product_laptop and product_tablet

class(refine_3$company_new)
refine_3$company_new <- factor(refine_3$company_new)
levels(refine_3$company_new)

refine_4 <- refine_3 %>% mutate(company_philips = ifelse(company_new == "philips",1,0)
                                ,company_akzo = ifelse(company_new=="akzo",1,0)
                                ,company_van_houten = ifelse(company_new=="van houten",1,0)
                                ,company_unilever=ifelse(company_new=="unilever",1,0))

select(refine_4,company_new,company_philips,company_akzo,company_van_houten,company_unilever)

class(refine_3$product_categories)
refine_3$product_cat <- factor(refine_3$product_categories)
levels(refine_3$product_cat)

refine_4 <- refine_3 %>% mutate(product_smartphone = ifelse(product_cat == "Smartphone",1,0)
                                ,product_tv = ifelse(product_cat=="TV",1,0)
                                ,product_laptop = ifelse(product_cat=="Labtop",1,0)
                                ,company_Tablet=ifelse(product_cat=="Tablet",1,0))
select(refine_4,product_cat,product_smartphone,product_tv,product_laptop,company_Tablet)

View(refine_4)

#export table
write.csv(refine_4,file = "refine.clean.csv")
