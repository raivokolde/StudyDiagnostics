library(shiny)
library(DT)
source("PlotsAndTables.R")

truncatestrings <- function(strings, maxLength = 100) {
  lens <- sapply(strings, function(x) tryCatch(nchar(x), error = function(e) 0), USE.NAMES = FALSE)
  idx <- lens > maxLength
  strings[idx] <- paste("...", substr(strings[idx], lens[idx] - maxLength, lens[idx])) 
  return(strings)
}

shinyServer(function(input, output, session) {

  cohortId <- reactive({
    return(cohort$cohortId[cohort$cohortName == input$cohort])
  })
  
  comparatorCohortId <- reactive({
    return(cohort$cohortId[cohort$cohortName == input$comparator])
  })
  
  observe({
    subset <- unique(conceptSets$conceptSetName[conceptSets$cohortId == cohortId()])
    updateSelectInput(session = session,
                      inputId = "conceptSet",
                      choices = subset)
  })
  

  output$incidenceProportionPlot <- renderPlot({
    data <- incidenceProportion[incidenceProportion$cohortId == cohortId() & 
                                  incidenceProportion$databaseId == input$database, ]
    plot <- StudyDiagnostics::plotIncidenceProportion(data)
    return(plot)
  })

  output$includedSourceConceptsTable <- renderDataTable({
    table <- includedSourceConcept[includedSourceConcept$cohortId == cohortId() &
                                     includedSourceConcept$conceptSetName == input$conceptSet & 
                                     includedSourceConcept$databaseId == input$database, ]
    table <- table[, c("conceptSubjects", "sourceVocabularyId", "conceptCode", "sourceConceptName")]
    table <- table[order(-table$conceptSubjects), ]
    colnames(table) <- c("Subjects", "Vocabulary", "Code", "Name")
    lims <- c(0, max(table$Subjects))
    options = list(pageLength = 25,
                   searching = TRUE,
                   lengthChange = TRUE,
                   ordering = TRUE,
                   paging = TRUE)
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    table <- DT::formatStyle(table = table,
                             columns = 1,
                             background = DT::styleColorBar(lims, "lightblue"),
                             backgroundSize = "98% 88%",
                             backgroundRepeat = "no-repeat",
                             backgroundPosition = "center")
    return(table)
  })

  output$orphanConceptsTable <- renderDataTable({
    table <- orphanConcept[orphanConcept$cohortId == cohortId() &
                             orphanConcept$conceptSetName == input$conceptSet & 
                             orphanConcept$databaseId == input$database, ]
    table <- table[, c("conceptCount", "standardConcept", "vocabularyId", "conceptCode", "conceptName")]
    table <- table[order(-table$conceptCount), ]
    colnames(table) <- c("Count", "Standard", "Vocabulary", "Code", "Name")
    lims <- c(0, max(table$Count))
    options = list(pageLength = 25,
                   searching = TRUE,
                   lengthChange = TRUE,
                   ordering = TRUE,
                   paging = TRUE)
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    table <- DT::formatStyle(table = table,
                             columns = 1,
                             background = DT::styleColorBar(lims, "lightblue"),
                             backgroundSize = "98% 88%",
                             backgroundRepeat = "no-repeat",
                             backgroundPosition = "center")
    return(table)
  })
  
  output$inclusionRuleTable <- renderDataTable({
    table <- inclusionRuleStats[inclusionRuleStats$cohortId == cohortId() & inclusionRuleStats$databaseId == input$database, ]
    table <- table[order(table$ruleSequenceId), ]
    table$cohortId <- NULL
    table$databaseId <- NULL
    colnames(table) <- c("Sequence", "Name", "Meet", "Gain", "Total", "Remain")
    options = list(pageLength = 25,
                   searching = TRUE,
                   lengthChange = TRUE,
                   ordering = TRUE,
                   paging = TRUE)
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    return(table)
  })
  
  output$breakdownTable <- renderDataTable({
    table <- indexEventBreakdown[indexEventBreakdown$cohortId == cohortId() & indexEventBreakdown$databaseId == input$database, ]
    table <- table[order(-table$conceptCount), ]
    table <- table[, c("conceptCount", "conceptId", "conceptName")]
    colnames(table) <- c("Count", "Concept ID", "Name")
    lims <- c(0, max(table$Count))
    options = list(pageLength = 25,
                   searching = TRUE,
                   lengthChange = TRUE,
                   ordering = TRUE,
                   paging = TRUE)
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    table <- DT::formatStyle(table = table,
                             columns = 1,
                             background = DT::styleColorBar(lims, "lightblue"),
                             backgroundSize = "98% 88%",
                             backgroundRepeat = "no-repeat",
                             backgroundPosition = "center")
    return(table)
  })
  
  output$characterizationTable <- renderDataTable({
    table <- covariateValue[covariateValue$cohortId == cohortId() & covariateValue$databaseId == input$database, ]
    # table <- covariateValue[covariateValue$cohortId == 13646, ]
    table <- merge(table, covariate)
    table$cohortId <- NULL
    table$databaseId <- NULL
    
    if (input$charType == "Pretty") {
    table <- prepareTable1(table, output = "HTML")
    options = list(pageLength = 999,
                   searching = FALSE,
                   lengthChange = FALSE,
                   ordering = FALSE,
                   paging = FALSE)
    } else {
      table <- table[order(table$covariateName), ]
      table <- table[, c("covariateName", "mean", "sd")]
      table$mean <- round(table$mean, 3)
      table$sd <- round(table$sd, 3)
      table$covariateName <- truncatestrings(table$covariateName, 140)
      colnames(table) <- c("Covariate name", "Mean", "SD")
      
      options = list(pageLength = 25,
                     searching = TRUE,
                     lengthChange = TRUE,
                     ordering = TRUE,
                     paging = TRUE)
    }
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    return(table)
  })
  
  output$overlapUi <- renderUI({
    
    data <- cohortOverlap[cohortOverlap$targetCohortId == cohortId() & 
                             cohortOverlap$comparatorCohortId == comparatorCohortId() &
                             cohortOverlap$databaseId == input$database, ]
    if (nrow(data) == 0) {
      return(NULL)
    }
    html <- paste("<table>",
      sprintf("<tr><td><b>Subject in either cohort</b></td><td>&nbsp;</td><td>%s</td></tr>", data$eitherSubjects),
      sprintf("<tr><td><b>Subject in both cohort</b></td><td>&nbsp;</td><td>%s</td></tr>", data$bothSubjects),
      sprintf("<tr><td><b>Subject in target not in comparator</b></td><td>&nbsp;</td><td>%s</td></tr>", data$tOnlySubjects),
      sprintf("<tr><td><b>Subject in comparator not in target</b></td><td>&nbsp;</td><td>%s</td></tr>", data$cOnlySubjects),
      sprintf("<tr><td><b>Subject in target before comparator</b></td><td>&nbsp;</td><td>%s</td></tr>", data$tBeforeCSubjects),
      sprintf("<tr><td><b>Subject in comparator before target</b></td><td>&nbsp;</td><td>%s</td></tr>", data$cBeforeTSubjects),
      sprintf("<tr><td><b>Subject in target and comparator on same day</b></td><td>&nbsp;</td><td>%s</td></tr>", data$sameDaySubjects),
      "</table>",
      sep = "\n")
    return(HTML(html))
  })
  
  output$charCompareTable <- renderDataTable({
    covs1 <- covariateValue[covariateValue$cohortId == cohortId() & covariateValue$databaseId == input$database, ]
    covs2 <- covariateValue[covariateValue$cohortId == comparatorCohortId() & covariateValue$databaseId == input$database, ]
    # covs1 <- covariateValue[covariateValue$cohortId == 13646, ]
    # covs2 <- covariateValue[covariateValue$cohortId == 13666, ]
    covs1 <- merge(covs1, covariate)
    covs2 <- merge(covs2, covariate)
    balance <- StudyDiagnostics::compareCohortCharacteristics(covs1, covs2)
    
    

    if (input$charCompareType == "Pretty") {
      balance <- merge(balance, covariate[, c("covariateId", "covariateAnalysisId")])
      table <- prepareTable1Comp(balance, output = "HTML")
      options = list(pageLength = 999,
                     searching = FALSE,
                     lengthChange = FALSE,
                     ordering = FALSE,
                     paging = FALSE)
    } else {
      table <- balance
      
      lens <- sapply(table$covariateName, function(x) tryCatch(nchar(x), error = function(e) 0), USE.NAMES = FALSE)
      table$covariateName <- truncatestrings(table$covariateName, 100)
      table <- table[order(table$covariateName), ]
      table <- table[, c("covariateName", "mean1", "sd1", "mean2", "sd2", "stdDiff")]
      table$mean1 <- round(table$mean1, 3)
      table$sd1 <- round(table$sd1, 3)
      table$mean2 <- round(table$mean2, 3)
      table$sd2 <- round(table$sd2, 3)
      table$stdDiff <- round(table$stdDiff, 3)
      colnames(table) <- c("Covariate name", "Mean T", "SD T", "Mean C", "SD C", "StdDiff")
      
      options = list(pageLength = 25,
                     searching = TRUE,
                     lengthChange = TRUE,
                     ordering = TRUE,
                     paging = TRUE)
    }
    table <- datatable(table,
                       options = options,
                       rownames = FALSE,
                       escape = FALSE,
                       class = "stripe nowrap compact")
    return(table)
  })
  
})
