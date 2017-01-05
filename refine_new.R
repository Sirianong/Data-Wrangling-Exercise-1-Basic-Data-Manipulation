## getting around with import column error by create vector name and replace 

header_refine <- c("company","product","address","city","country","name")
print(header_refine)
colnames(refine) <- header_refine
View(refine)
refine_1 <- refine[-1,]

## 1. clean up brand names
refine_1$company <- tolower(refine_1$company)

View(refine_1)

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
class(refine_3$company)
refine_3$company <- factor(refine_3$company)
levels(refine_3$company)

refine_3 %>% mutate(company_phillips = ifelse(company = phillips,1,0),company_akzo)




## 6. doing some stupid thing to see git checkout--play matrix
a<-matrix(1:6,nrow=2)

