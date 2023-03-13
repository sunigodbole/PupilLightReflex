sigRegion <- function(df, crit.val, imp.var){
  time <- imp.var[1]
  est <- imp.var[2]
  lci <- imp.var[3]
  uci <- imp.var[4]


  crit.rows <- which((df[, lci] < crit.val & df[, uci] < crit.val) |
                       (df[, lci] > crit.val & df[, uci] > crit.val))

  # print(crit.rows)

  group <- vector(mode = "numeric", length = length(crit.rows))
  grp.ind <- 1
  for(i in 1:length(crit.rows)){
    if(i == 1){
      group[i] <- grp.ind}
    else(if(i > 1){
      if(crit.rows[i] - crit.rows[i-1] == 1){
        group[i] <- grp.ind
      }
      else(if(crit.rows[i] - crit.rows[i-1] != 1){
        grp.ind <- grp.ind+1
        group[i] <- grp.ind
      })
    })

  }
  # print(group)

  num.grp <- unique(group)
  ind.df <- data.frame(group = NA,
                       start = NA,
                       end = NA)
  for(i in num.grp){
    ind.df[i,] <- c(i, min(crit.rows[group == i]), max(crit.rows[group == i]))
  }

  # print(ind.df)

  res.df <- data.frame(int.start = NA,
                       int.end = NA,
                       est.time = NA,
                       est = NA,
                       lci = NA,
                       uci = NA)
  # print(nrow(ind.df))

  for(i in 1:nrow(ind.df)){

    sub.df <- df[(ind.df$start[i]):(ind.df$end[i]), ]

    # print(sub.df[1, ])

    if(sub.df[1, lci] > crit.val & sub.df[1, uci] >crit.val){
      start1 <- round(sub.df[1, time], 2)
      end1 <- round(sub.df[nrow(sub.df), time], 2)
      or1 <- max(sub.df[ , est])
      peaktime1 <- round(sub.df[sub.df[, est] == or1, time], 2)
      lci1 <- round(sub.df[sub.df[, est] == or1, lci], 2)
      uci1 <- round(sub.df[sub.df[, est] == or1, uci], 2)
      or1 <- round(or1, 2)

      res.df[i, ] <- c(start1, end1, peaktime1, or1, lci1, uci1)
      # print(res.df)

    }
    if(sub.df[1, lci] < crit.val & sub.df[1, uci] < crit.val){
      start2 <- round(sub.df[1, time], 2)
      end2 <- round(sub.df[nrow(sub.df), time], 2)
      or2 <- min(sub.df[, est])
      peaktime2 <- round(sub.df[sub.df[, est] == or2, time], 2)
      lci2 <- round(sub.df[sub.df[, est] == or2, lci], 2)
      uci2 <- round(sub.df[sub.df[, est] == or2, uci], 2)
      or2 <- round(or2, 2)

      res.df[i, ] <- c(start2, end2, peaktime2, or2, lci2, uci2)
      # print(res.df)
    }
  }


  # crit.ind <- by(crit.rows, INDICES = list(group), FUN = function(x) c(min(x), max(x)))
  return(res.df)
}


sigRegion(pred_coef_df, crit.val = 0, imp.var = c("seconds", "f1_hat", "f1_lci", "f1_uci"))
