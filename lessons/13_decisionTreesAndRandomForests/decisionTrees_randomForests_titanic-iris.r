# Decision Trees and Random Forests :: Titanic and Iris datasets
# Another cool Data Dashboard app

library(shiny)
library(ggplot2)
library(DT)
library(randomForest)
library(caret)
library(rpart)
library(rpart.plot)
library(shinyjs)

# Load Titanic dataset (you can also use the titanic dataset from the titanic package)
# Here, we're using a sample Titanic dataset available within R
titanic_data <- as.data.frame(Titanic)
titanic_data$Survived <- factor(titanic_data$Survived)

# Also, Load Iris dataset
iris_data <- iris

# Add code to loadother datasets as necessary, introduce them as options below.


# UI
ui <- fluidPage(
  useShinyjs(),
  titlePanel("Decision Tree and Random Forest Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a Dataset:",
                  choices = c("Titanic", "Iris")), 
      uiOutput("var_select"),  # Dynamically generated UI for target variable
      actionButton("train_model", "Train Model"),
      hr(),
      actionButton("help_button", "Help")
    ),
    mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel("Dataset", DTOutput("dataset_table")),
        tabPanel("Decision Tree", plotOutput("tree_plot")),
        tabPanel("Random Forest", plotOutput("rf_plot")),
        tabPanel("Model Performance", verbatimTextOutput("model_performance")),
        tabPanel("Help", uiOutput("help_text"))
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Reactive dataset based on user selection
  dataset_reactive <- reactive({
    if (input$dataset == "Titanic") {
      return(titanic_data)
    } else {
      return(iris_data)
    }
  })
  
  # Update UI based on selected dataset
  output$var_select <- renderUI({
    data <- dataset_reactive()
    target_choices <- names(data)
    
    # For Titanic, "Survived" is typically the target; for Iris, "Species" is the target.
    selected_target <- if (input$dataset == "Titanic") "Survived" else "Species"
    
    selectInput("target", "Select Target Variable:",
                choices = target_choices, selected = selected_target)
  })
  
  # Train Decision Tree and Random Forest models
  observeEvent(input$train_model, {
    data <- dataset_reactive()
    target <- input$target
    
    # Decision Tree
    tree_model <- rpart(as.formula(paste(target, "~ .")), data = data, method = "class")
    
    # Random Forest
    rf_model <- randomForest(as.formula(paste(target, "~ .")), data = data)
    
    # Decision Tree Plot
    output$tree_plot <- renderPlot({
      rpart.plot(tree_model, main = "Decision Tree")
    })
    
    # Random Forest Variable Importance Plot
    output$rf_plot <- renderPlot({
      varImpPlot(rf_model, main = "Random Forest - Variable Importance")
    })
    
    # Model Performance (Accuracy)
    output$model_performance <- renderPrint({
      tree_pred <- predict(tree_model, data, type = "class")
      rf_pred <- predict(rf_model, data)
      
      tree_accuracy <- mean(tree_pred == data[[target]]) #determine mean
      rf_accuracy <- mean(rf_pred == data[[target]]) #determine mean
      
      list(
        Tree_Accuracy = tree_accuracy,
        RF_Accuracy = rf_accuracy
      )
    })
    
    # Dataset table
    output$dataset_table <- renderDT({
      datatable(data)
    })
    
    # Help text, own tab, cheesy but might be useful after more editing...
    # use html to format text
    output$help_text <- renderUI({
      HTML("
        <h3>Decision Tree & Random Forest Explanation</h3>
        <p><b>Decision Tree:</b> A decision tree is a supervised learning model used for classification or regression. It splits data into subsets based on feature values and assigns a label to each terminal node.</p>
        <p><b>Random Forest:</b> Random forest is an ensemble method that uses multiple decision trees to improve accuracy and reduce overfitting. The algorithm selects a random subset of features and builds a decision tree for each subset, then aggregates the results from all the trees to make a final prediction.</p>
        <p><b>Visual Outputs:</b></p>
        <ul>
          <li><b>Decision Tree:</b> The tree plot visualizes the splits in the decision tree, showing how the data is divided based on various features. It helps to understand how decisions are made.</li>
          <li><b>Random Forest Variable Importance:</b> This plot shows which features are most important in predicting the target variable. Higher values indicate more importance.</li>
        </ul>
        <p><b>Performance Metrics:</b> The accuracy of both the Decision Tree and Random Forest models are computed and displayed. A higher accuracy indicates a better model. The accuracy is calculated by comparing the model's predictions against the true values of the target variable.</p>
      ")
    })
  })
  
  # Show the Help tab when Help button is pressed
  observeEvent(input$help_button, {
    updateTabsetPanel(session, "tabs", selected = "Help")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
