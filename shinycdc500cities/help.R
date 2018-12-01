disease_map <- function(disease, mapdata){
  library(maps)
  USA <- map_data("state")
  usa <- USA[!(USA$region %in% c("alaska","hawaii")),]
  plot <- ggplot() + geom_polygon(aes(long,lat, group=group), color='white', fill="grey65", data=USA) + geom_point(data=mapdata[mapdata$Short_Question_Text == disease,], aes(long,lat,color=Data_Value))
  print(plot)
}

disease_bar_plot <- function(disease, health_outcomes){
  a <- aggregate(health_outcomes[[disease]] ~ health_outcomes$StateDesc, FUN = mean)
  plot <- ggplot(a, aes(reorder(a[,1], -a[,2]), a[,2])) + geom_bar(stat = "identity") + 
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) + 
    labs(title="Rate of the disease by State", x="State", y="Percent of Population")
  print(plot)
}