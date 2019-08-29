# Generating new datasets

library(datasets)

# information on the datasets available
library(help = "datasets")

# modified iris

data = datasets::iris %>% as_tibble
data

data$subtype = if_else(data$Sepal.Length >= mean(data$Sepal.Length),
                       paste0("long_",data$Species),
                       paste0("short_",data$Species)) %>% as_factor

view(data)

summary(data)

write_csv(data,"data/iris_modified.csv")


# modified mtcars


dataset = datasets::mtcars %>% 
  as_tibble %>% mutate(type = if_else(cyl==4,"four_cylinders",
                                      if_else(cyl==6,"six_cylinders",
                                              if_else(cyl==8,"eight_cylinders","NA" ))))


dataset

write_csv(dataset,"data/mt_cars_modified.csv")