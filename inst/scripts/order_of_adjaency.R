# 加载必要的包
library(spdep)
library(ggplot2)
library(sf)
library(showtext)
# 创建一个简单的 3x3 网格
coords <- expand.grid(x = 1:3, y = 1:3)
n <- nrow(coords)

# 转换为空间对象
sf_points <- st_as_sf(coords, coords = c("x", "y"))

# 使用queen准则创建邻接矩阵
nb <- spdep::dnearneigh(as.matrix(coords), d1 = 0, d2 = 1.5)
# 转换为邻接列表
nb_list <- spdep::nb2listw(nb, style = "B")

# 提取一阶邻接矩阵
W <- spdep::nb2mat(nb, style = "B")
rownames(W) <- colnames(W) <- paste0("P", 1:n)

# 计算二阶邻接矩阵
W2 <- W %*% W
diag(W2) <- 0  # 将对角线设为0
W2[W2 > 0] <- 1  # 二值化
# 设置图形布局
par(mfrow = c(1, 2), mar = c(2, 2, 3, 2))

# 绘制一阶邻接
plot(coords, pch = 19, cex = 2, col = "blue", 
     main = "一阶邻接 (First Order Adjacency)",
     xlim = c(0.5, 3.5), ylim = c(0.5, 3.5),
     xlab = "", ylab = "", axes = FALSE)
text(coords, labels = paste0("P", 1:n), pos = 3, cex = 1.2)

# 添加邻接线
for (i in 1:n) {
  neighbors <- which(W[i, ] == 1)
  for (j in neighbors) {
    if (i < j) {
      lines(c(coords[i, 1], coords[j, 1]), 
            c(coords[i, 2], coords[j, 2]), 
            col = "red", lwd = 2)
    }
  }
}
grid()

# 绘制二阶邻接
plot(coords, pch = 19, cex = 2, col = "darkgreen", 
     main = "二阶邻接 (Second Order Adjacency)",
     xlim = c(0.5, 3.5), ylim = c(0.5, 3.5),
     xlab = "", ylab = "", axes = FALSE)
text(coords, labels = paste0("P", 1:n), pos = 3, cex = 1.2)

# 添加二阶邻接线
for (i in 1:n) {
  neighbors <- which(W2[i, ] == 1)
  for (j in neighbors) {
    if (i < j) {
      lines(c(coords[i, 1], coords[j, 1]), 
            c(coords[i, 2], coords[j, 2]), 
            col = "orange", lwd = 2, lty = 2)
    }
  }
}
grid()




# 创建示例网格数据
set.seed(123)
grid_data <- expand.grid(x = 1:5, y = 1:5) %>%
  mutate(
    id = paste0("P", row_number()),
    type = ifelse(x == 3 & y == 3, "中心单元", "周边单元"),
    order = case_when(
      abs(x-3) + abs(y-3) == 0 ~ 0,  # 中心
      abs(x-3) + abs(y-3) == 1 ~ 1,  # 一阶邻接
      abs(x-3) + abs(y-3) == 2 ~ 2,  # 二阶邻接
      TRUE ~ 3                       # 三阶及以上
    )
  )

# 创建邻接关系数据
create_edges <- function(data, max_order = 2) {
  edges <- data.frame()
  center <- data %>% filter(x == 3, y == 3)
  
  for (ord in 1:max_order) {
    # 获取当前阶数的邻接单元
    neighbors <- data %>%
      filter(
        abs(x - center$x) + abs(y - center$y) == ord,
        order == ord
      )
    
    # 创建连接线
    for (i in 1:nrow(neighbors)) {
      edges <- rbind(edges, data.frame(
        from_x = center$x,
        from_y = center$y,
        to_x = neighbors$x[i],
        to_y = neighbors$y[i],
        order = paste0("阶数 ", ord),
        color = ord
      ))
    }
  }
  return(edges)
}

edges <- create_edges(grid_data, 2)

# 绘制示意图
ggplot() +
  # 绘制连接线
  geom_segment(data = edges,
               aes(x = from_x, xend = to_x,
                   y = from_y, yend = to_y,
                   color = factor(order)),
               size = 2, alpha = 0.7) +
  
  # 绘制网格点
  geom_point(data = grid_data,
             aes(x = x, y = y, fill = factor(order)),
             shape = 21, size = 12, color = "black", stroke = 1) +
  
  # 添加标签
  geom_text(data = grid_data,
            aes(x = x, y = y, label = id),
            size = 4, fontface = "bold") +
  
  # 颜色和主题设置
  scale_color_manual(values = c("阶数 1" = "#E41A1C", "阶数 2" = "#377EB8")) +
  scale_fill_manual(values = c("0" = "gold", "1" = "#E41A1C", 
                               "2" = "#377EB8", "3" = "grey80"),
                    labels = c("中心单元", "一阶邻接", 
                               "二阶邻接", "三阶及以上")) +
  
  # 图例和标签
  labs(
    title = "邻接阶数示意图",
    subtitle = "展示不同阶数的空间邻接关系",
    x = NULL, y = NULL,
    fill = "单元类型",
    color = "邻接阶数"
  ) +
  
  theme_minimal() +
  theme(
    text = element_text(family = "KaiTi",
                        size = 12),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.box = "horizontal"
  ) +
  coord_fixed(ratio = 1)

ggsave("order_adjancy.jpg",width = 8, height = 6)


library(readr)
library(tidyverse)
mili_expen<- read_csv("data/API_MS.MIL.XPND.GD.ZS_DS2_en_csv_v2_50.csv", 
                                                   skip = 3)
View(mili_expen)
mili_expen <- pivot_longer(mili_expen, cols = `1960`:`2024`,
                                names_to = "year",
                                values_to = "mili_expen")

mili_expen <- mili_expen %>% 
          dplyr::mutate(gwcode = countrycode(`Country Code`,"iso3c", "gwn"))
mili_expen <- mili_expen %>% 
        dplyr::select(gwcode, year, mili_expen) %>% 
        dplyr::filter(!is.na(gwcode))
save(mili_expen, file = "data/mili_expen.RData")
