library(ggplot2)
library(dplyr)
library(scales)
library(ggrepel)

outdir <- "/Users/briggsd/Library/CloudStorage/Dropbox/personal-website/posts/2026-02-27_AI Literacy Pt 3"

company_colors <- c(
  "OpenAI"    = "#10a37f",
  "Anthropic" = "#CC5500",
  "Google"    = "#4285F4",
  "Meta"      = "#7B5EA7"
)

# ============================================================
# Plot 1: Context Window Size Over Time (updated through early 2026)
# Key addition: Llama 4 Scout at 10M tokens — a 2,500x increase since GPT-3
# ============================================================

ctx <- data.frame(
  model = c(
    "GPT-3",
    "GPT-3.5 Turbo (ChatGPT launch)",
    "GPT-4 (8K)",
    "GPT-4 (32K)",
    "Claude 2",
    "GPT-4 Turbo",
    "Gemini 1.5 Pro",
    "Claude 3 Opus",
    "GPT-4o",
    "Llama 3.1 (405B)",
    "Gemini 1.5 Pro 002",
    "Gemini 2.0 Flash",
    "Claude 3.7 Sonnet",
    "GPT-4.1",
    "Llama 4 Maverick",
    "Llama 4 Scout",
    "GPT-5",
    "GPT-5.2"
  ),
  date = as.Date(c(
    "2020-06-01",
    "2022-11-30",
    "2023-03-14",
    "2023-03-14",
    "2023-07-11",
    "2023-11-06",
    "2024-02-15",
    "2024-03-04",
    "2024-05-13",
    "2024-07-23",
    "2024-09-24",
    "2024-12-11",
    "2025-02-24",
    "2025-04-14",
    "2025-04-05",
    "2025-04-05",
    "2025-08-07",
    "2025-12-11"
  )),
  context_k = c(
    4, 4, 8, 32, 100, 128,
    1000, 200, 128, 128,
    2000, 1000,
    200, 1000, 1000, 10000,
    400, 400
  ),
  company = c(
    "OpenAI", "OpenAI", "OpenAI", "OpenAI",
    "Anthropic", "OpenAI",
    "Google", "Anthropic", "OpenAI", "Meta",
    "Google", "Google",
    "Anthropic", "OpenAI", "Meta", "Meta",
    "OpenAI", "OpenAI"
  )
)

p1 <- ggplot(ctx, aes(x = date, y = context_k, color = company, label = model)) +
  geom_point(size = 3.5, alpha = 0.9) +
  geom_text_repel(
    size = 2.7, lineheight = 0.85,
    box.padding = 0.4, point.padding = 0.3,
    min.segment.length = 0.2,
    show.legend = FALSE, max.overlaps = 30,
    segment.color = "gray70", segment.size = 0.3
  ) +
  scale_y_log10(
    breaks = c(4, 8, 32, 100, 128, 200, 400, 1000, 2000, 10000),
    labels = c("4K", "8K", "32K", "100K", "128K", "200K", "400K", "1M", "2M", "10M"),
    minor_breaks = NULL
  ) +
  scale_x_date(
    date_breaks = "6 months",
    date_labels = "%b\n'%y",
    limits = as.Date(c("2020-01-01", "2026-06-01"))
  ) +
  scale_color_manual(values = company_colors) +
  labs(
    title = "Context Window Size of Frontier LLMs, 2020\u20132025",
    subtitle = "2,500\u00d7 increase in five years: from 4K tokens (GPT-3, 2020) to 10M tokens (Llama 4 Scout, 2025)",
    x = NULL,
    y = "Max Context Window (log scale)",
    color = NULL,
    caption = "Sources: Official model documentation. Dates approximate for some 2025 models."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "gray35", size = 10),
    plot.caption  = element_text(color = "gray50", size = 8),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90"),
    axis.text.y   = element_text(size = 9)
  )

ggsave(file.path(outdir, "plot1_context_window.png"), p1,
       width = 11, height = 7, dpi = 150, bg = "white")
message("Plot 1 saved.")


# ============================================================
# Plot 2a: MMLU — Rapid Rise, Then Saturation
# ============================================================

mmlu <- data.frame(
  model = c(
    "GPT-3", "GPT-3.5", "Llama 2 (70B)", "Claude 2",
    "GPT-4",
    "Gemini Ultra 1.0", "Claude 3 Opus", "GPT-4o",
    "Llama 3.1 (405B)", "Claude 3.5 Sonnet"
  ),
  date = as.Date(c(
    "2020-06-01", "2022-11-30", "2023-07-18", "2023-07-11",
    "2023-03-14",
    "2023-12-06", "2024-03-04", "2024-05-13",
    "2024-07-23", "2024-10-22"
  )),
  score = c(43.9, 70.0, 68.9, 78.5, 86.4, 90.0, 88.7, 88.7, 88.6, 88.7),
  company = c(
    "OpenAI", "OpenAI", "Meta", "Anthropic",
    "OpenAI",
    "Google", "Anthropic", "OpenAI",
    "Meta", "Anthropic"
  )
)

p2a <- ggplot(mmlu, aes(x = date, y = score, color = company, label = model)) +
  geom_hline(yintercept = 90, linetype = "dashed", color = "gray55", linewidth = 0.5) +
  geom_point(size = 3.5, alpha = 0.9) +
  geom_text_repel(
    size = 2.7, lineheight = 0.85,
    box.padding = 0.4, point.padding = 0.3,
    show.legend = FALSE, max.overlaps = 20,
    segment.color = "gray70", segment.size = 0.3
  ) +
  annotate("text", x = as.Date("2020-03-01"), y = 91.3,
           label = "~90% ceiling (effective saturation)", color = "gray45", size = 3, hjust = 0) +
  annotate("text", x = as.Date("2025-01-01"), y = 84,
           label = "By 2025, all frontier\nmodels score 88\u201392%",
           color = "gray40", size = 2.8, hjust = 0.5, fontface = "italic") +
  scale_color_manual(values = company_colors) +
  scale_y_continuous(limits = c(35, 100), breaks = seq(40, 100, 10),
                     labels = function(x) paste0(x, "%")) +
  scale_x_date(date_breaks = "6 months", date_labels = "%b\n'%y",
               limits = as.Date(c("2020-01-01", "2025-09-01"))) +
  labs(
    title = "MMLU Benchmark: Rapid Rise, Then Saturation",
    subtitle = "MMLU = 57-subject academic test. GPT-3 scored 44% in 2020; frontier models now cluster near 90%.",
    x = NULL, y = "MMLU Score", color = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(color = "gray35", size = 9),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

ggsave(file.path(outdir, "plot2a_mmlu.png"), p2a,
       width = 9, height = 6, dpi = 150, bg = "white")
message("Plot 2a saved.")


# ============================================================
# Plot 2b: GPQA Diamond — The New Frontier (updated through Feb 2026)
# Human expert baseline ~65%. Models now exceeding 94%.
# ============================================================

gpqa <- data.frame(
  model = c(
    "Claude 3 Opus",
    "GPT-4o",
    "Claude 3.5 Sonnet",
    "o1-preview",
    "o1",
    "Claude 3.7 Sonnet",
    "Gemini 2.5 Pro",
    "Claude Opus 4.6",    # approximate date; from aggregator source
    "Gemini 3.1 Pro"      # approximate date; from aggregator source
  ),
  date = as.Date(c(
    "2024-03-04",
    "2024-05-13",
    "2024-06-20",
    "2024-09-12",
    "2024-12-05",
    "2025-02-24",
    "2025-03-25",
    "2025-07-01",
    "2026-01-15"
  )),
  score = c(50.4, 53.6, 59.4, 73.3, 78.3, 84.8, 84.0, 91.3, 94.3),
  company = c(
    "Anthropic", "OpenAI", "Anthropic",
    "OpenAI", "OpenAI",
    "Anthropic", "Google",
    "Anthropic", "Google"
  )
)

p2b <- ggplot(gpqa, aes(x = date, y = score, color = company, label = model)) +
  geom_hline(yintercept = 65, linetype = "dashed", color = "gray55", linewidth = 0.5) +
  geom_hline(yintercept = 25, linetype = "dotted", color = "gray70", linewidth = 0.4) +
  geom_point(size = 3.5, alpha = 0.9) +
  geom_text_repel(
    size = 2.7, lineheight = 0.85,
    box.padding = 0.4, point.padding = 0.3,
    show.legend = FALSE, max.overlaps = 20,
    segment.color = "gray70", segment.size = 0.3
  ) +
  annotate("text", x = as.Date("2024-01-20"), y = 66.5,
           label = "Human expert baseline (~65%)", color = "gray40", size = 3, hjust = 0) +
  annotate("text", x = as.Date("2024-01-20"), y = 26.5,
           label = "Random chance (25%)", color = "gray55", size = 2.7, hjust = 0) +
  scale_color_manual(values = company_colors) +
  scale_y_continuous(limits = c(20, 100), breaks = seq(20, 100, 10),
                     labels = function(x) paste0(x, "%")) +
  scale_x_date(date_breaks = "3 months", date_labels = "%b\n'%y",
               limits = as.Date(c("2024-01-01", "2026-06-01"))) +
  labs(
    title = "GPQA Diamond: Frontier Models Now Surpass Human Experts",
    subtitle = "198 PhD-level science questions. In under two years, top models went from 50% to 94%.",
    x = NULL, y = "GPQA Diamond Score", color = NULL,
    caption = "Sources: Official model technical reports; aggregated scores from artificialanalysis.ai and bracai.eu.\nDates for Claude Opus 4.6 and Gemini 3.1 Pro are approximate. Human expert baseline from Rein et al. (2023)."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(color = "gray35", size = 9),
    plot.caption  = element_text(color = "gray50", size = 8),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave(file.path(outdir, "plot2b_gpqa.png"), p2b,
       width = 9, height = 6.5, dpi = 150, bg = "white")
message("Plot 2b saved.")


# ============================================================
# Plot 3: API Cost Per Million Input Tokens (updated through early 2026)
# Story: 1,200x drop from GPT-3 davinci to GPT-5 Nano
# ============================================================

cost <- data.frame(
  model = c(
    "GPT-3 (davinci)",
    "GPT-3.5 Turbo (launch)",
    "GPT-4 (8K)",
    "GPT-4 Turbo",
    "Claude 3 Opus",
    "GPT-4o",
    "Claude 3.5 Sonnet",
    "GPT-4o mini",
    "Claude 3.5 Haiku",
    "Gemini 2.0 Flash",
    "Gemini 2.5 Pro",
    "GPT-5",
    "Claude Haiku 4.5",
    "Gemini 3 Flash",
    "GPT-5 Mini",
    "Gemini 3 Pro",
    "Claude Sonnet 4.5",
    "Claude Opus 4.5",
    "GPT-5 Nano"
  ),
  date = as.Date(c(
    "2020-06-01",
    "2023-03-01",
    "2023-03-14",
    "2023-11-06",
    "2024-03-04",
    "2024-05-13",
    "2024-10-22",
    "2024-07-18",
    "2024-11-04",
    "2024-12-11",
    "2025-03-25",
    "2025-08-07",
    "2025-07-15",   # approximate
    "2025-11-01",   # approximate
    "2025-08-07",
    "2025-11-01",   # approximate
    "2025-07-01",   # approximate
    "2025-07-01",   # approximate
    "2025-08-07"
  )),
  cost_per_m = c(
    60.00,
    2.00,
    30.00,
    10.00,
    15.00,
    5.00,
    3.00,
    0.15,
    0.80,
    0.10,
    1.25,
    1.25,
    1.00,
    0.50,
    0.25,
    2.00,
    3.00,
    5.00,
    0.05
  ),
  tier = c(
    "Flagship", "Affordable", "Flagship", "Flagship",
    "Flagship", "Flagship", "Flagship",
    "Affordable", "Affordable", "Affordable",
    "Flagship", "Flagship",
    "Affordable", "Affordable",
    "Affordable", "Flagship",
    "Flagship", "Flagship",
    "Affordable"
  ),
  company = c(
    "OpenAI", "OpenAI", "OpenAI", "OpenAI",
    "Anthropic", "OpenAI", "Anthropic",
    "OpenAI", "Anthropic", "Google",
    "Google", "OpenAI",
    "Anthropic", "Google",
    "OpenAI", "Google",
    "Anthropic", "Anthropic",
    "OpenAI"
  )
)

p3 <- ggplot(cost, aes(x = date, y = cost_per_m, color = company,
                        shape = tier, label = model)) +
  geom_point(size = 3.5, alpha = 0.9) +
  geom_text_repel(
    size = 2.6, lineheight = 0.85,
    box.padding = 0.4, point.padding = 0.3,
    show.legend = FALSE, max.overlaps = 30,
    segment.color = "gray70", segment.size = 0.3
  ) +
  scale_y_log10(
    breaks = c(0.05, 0.10, 0.15, 0.25, 0.50, 1, 2, 5, 10, 15, 30, 60),
    labels = c("$0.05", "$0.10", "$0.15", "$0.25", "$0.50",
               "$1", "$2", "$5", "$10", "$15", "$30", "$60"),
    minor_breaks = NULL
  ) +
  scale_x_date(
    date_breaks = "6 months",
    date_labels = "%b\n'%y",
    limits = as.Date(c("2020-01-01", "2026-06-01"))
  ) +
  scale_color_manual(values = company_colors) +
  scale_shape_manual(values = c("Flagship" = 16, "Affordable" = 17)) +
  labs(
    title = "API Cost Per Million Input Tokens, 2020\u20132025",
    subtitle = "1,200\u00d7 price drop: from $60/M tokens (GPT-3, 2020) to $0.05/M tokens (GPT-5 Nano, 2025)",
    x = NULL,
    y = "Price per 1M Input Tokens (USD, log scale)",
    color = NULL, shape = "Model tier",
    caption = "Sources: Official provider pricing pages at approximate time of launch. Some 2025 dates are approximate.\nNote: more capable models now cost less than less capable models did two years prior."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "gray35", size = 10),
    plot.caption  = element_text(color = "gray50", size = 8),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90")
  )

ggsave(file.path(outdir, "plot3_cost.png"), p3,
       width = 11, height = 7, dpi = 150, bg = "white")
message("Plot 3 saved.")
message("All done.")
