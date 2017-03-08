# Server
shinyServer(function(input, output, session) {

  values <- reactiveValues()
  values$year <- 2000

  ranges <- reactiveValues(x = NULL, y = NULL)
  
  president_filtered <- reactive({
      data1 <- baby_names %>% filter(first == input$president_selection, gender == "boy")
      values$year <- filter(presidents, first == input$president_selection)$year
      return(data1)
  })
  singer_filtered <- reactive({
      data2 <- baby_names %>% filter(first == input$singer_selection)
      values$year <- filter(grammys, first == input$singer_selection)$year
      return(data2)
  })
  author_filtered <- reactive({
      data3 <- baby_names %>% filter(first == input$author_selection) 
      values$year <- filter(authors, first == input$author_selection)$year
 
    return(data3)
  })
  
  output$president_plot <- renderPlot({
    p <- ggplot((data = president_filtereed()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(p)
  })
  output$plot2 <- renderPlot({
    q <- ggplot((data = singer_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(q)
  })
  output$plot3 <- renderPlot({
    w <- ggplot((data = author_filtered()), mapping = aes(x = year, y = percent)) +
      geom_point() +
      geom_vline(xintercept = values$year) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y)
    
    
    return(w)
  })
  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$brush_info <- renderPrint({
    cat("input$plot_brush:\n")
    str(input$plot_brush)
  })
  
  output$click_info <- renderPrint({
    cat("input$plot_click:\n")
    str(input$plot_click)
  })
  
  output$president_table <- renderDataTable({
    return(president_filtered())
  })
  
  #returns a summary of the filtered data
  output$president_summary <- renderPrint({
    summary(data.frame(president_filtered()))
  })
})

