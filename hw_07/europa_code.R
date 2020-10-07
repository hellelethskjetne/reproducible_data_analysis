# Required packages that must be installed
library(ggplot2)
library(Cairo)

# Load Data and Set Working Directory
data_europa = read.csv(file = "C:/Users/Helle/Documents/SwRI Work/Chaotic Terrain/Final Data/Europa/europa_data.csv", header = TRUE, sep = ",")
data_europa

# Layout Template
histo_layout =  theme(
  axis.title.x = element_text(size = 35, face = "bold"),
  axis.title.y = element_text(size = 35, face = "bold"),
  legend.title = element_text(size = 35, face = "bold"),
  legend.text = element_text(size = 35),
  legend.key.size = unit(2.5, "lines"),
  axis.text.x = element_text(size = 40, face = "bold", color = "black"),
  axis.text.y = element_text(size = 40, face = "bold", color = "black"),
  panel.grid.major = element_line(color = "grey70", size = 0.5),
  panel.background = element_rect(fill = "white"),
  panel.border = element_rect(colour = "black", fill = NA, size = 1),
  axis.line.y = element_line(color = "black", size = 1),
  axis.line.x.top = element_line(color = "black", size = 1),
  axis.ticks = element_line(color = "black", size = 1),
  axis.ticks.length = unit(0.3, "cm")
)

# Calculating Binwidth (Freedman-Diaconis Rule)
bw_europa <- 2 * IQR(data_europa$Height) / length(data_europa$Height)^(1/3)
bw_europa

  ## height                diameter         axial ratio
  #  0.017 = ~0.02         0.69 = ~ 1       0.17 = ~ 0.2 

min_hgt = min(data_europa$Height)
min_hgt
max_hgt = max(data_europa$Height)
max_hgt
min_dia = min(data_europa$Diameter)
min_dia
max_dia = max(data_europa$Diameter)
max_dia


# Height Histogram
europa_hgt_hist = ggplot(data = data_europa, aes(x = Height, fill = Region)) + 
  geom_histogram(binwidth = 0.025, boundary = 0, color = "black") +
  scale_x_continuous(breaks = seq(0, 0.6, by = 0.1)) +
  scale_y_continuous(breaks = seq(0,100, by = 10)) +
  scale_fill_manual(values = c("#660066","#E69F00", "#00FFFF")) +
  labs(x = "Height (km)", y = "Number of Features per Bin", fill = "Location") 
europa_hgt_hist + histo_layout

europa_hgt_hist = ggplot(data = data_europa, aes(x = Height, color = Region)) + 
  geom_freqpoly(size = 2.5, binwidth = 0.025, linejoin = 'round') +
  scale_x_continuous(breaks = seq(0, 0.6, by = 0.1)) +
  scale_y_continuous(breaks = seq(0,100, by = 10)) +
  theme(legend.position = c(0.85,0.85), legend.title = element_blank(), legend.background = element_rect(linetype = "solid", colour = "black")) +
  scale_color_manual(values = c("#660066","#E69F00", "#00FFFF")) +
  labs(x = "Height (km)", y = "Number of Features per Bin", fill = "Location") 
europa_hgt_hist + histo_layout



# Diameter Histogram
europa_dia_hist = ggplot(data = data_europa, aes(x = Diameter, color = Region)) + 
  geom_freqpoly(size = 2.5, binwidth = 1, linejoin = 'round') +
  scale_x_continuous(breaks = seq(0, 14, by = 2)) +
  scale_y_continuous(breaks = seq(0,50, by = 10)) +
  scale_color_manual(values = c("#000000","#E69F00", "#00FFFF")) +
  theme(legend.position = c(0.85,0.85), legend.title = element_blank(), legend.background = element_rect(linetype = "solid", colour = "black")) +
  labs(x = "Diameter (km)", y = "Number of Features per Bin", fill = "Region") 
europa_dia_hist + histo_layout

# Axial Ratio Histogram
europa_ar_hist = ggplot(data = data_europa, aes(x = data_europa$Axis.Ratio, color = Region)) + 
  geom_freqpoly(size = 2.5, binwidth = 0.2, linejoin = 'round') +
  scale_x_continuous(breaks = seq(0, 4.4, by = 0.4)) +
  scale_y_continuous(breaks = seq(0,100, by = 10)) +
  scale_color_manual(values = c("#0072B2","#000000", "#FF6699")) +
  theme(legend.position = c(0.85,0.85), legend.title = element_blank(), legend.background = element_rect(linetype = "solid", colour = "black")) +
  labs(x = "Axial Ratio", y = "Number of Features per Bin", col = "Region") 
europa_ar_hist + histo_layout