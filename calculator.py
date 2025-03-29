# Simple GUI calculator in PyNova
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout
from PyQt5.QtWidgets import QPushButton, QLineEdit, QLabel, QGridLayout
from PyQt5.QtCore import Qt

class CalculatorApp:
    def __init__(self):
        self.app = QApplication([])
        self.window = QMainWindow()
        self.window.setWindowTitle("PyNova Calculator")
        self.window.setGeometry(100, 100, 300, 400)
        
        # Create central widget and layout
        self.central_widget = QWidget()
        self.main_layout = QVBoxLayout(self.central_widget)
        
        # Create display
        self.display = QLineEdit()
        self.display.setReadOnly(True)
        self.display.setAlignment(Qt.AlignRight)
        self.display.setStyleSheet("font-size: 24px; padding: 10px;")
        self.main_layout.addWidget(self.display)
        
        # Create buttons layout
        self.buttons_layout = QGridLayout()
        
        # Create number buttons
        self.create_number_buttons()
        
        # Create operation buttons
        self.create_operation_buttons()
        
        # Add buttons layout to main layout
        self.main_layout.addLayout(self.buttons_layout)
        
        # Set central widget
        self.window.setCentralWidget(self.central_widget)
        
        # Initialize calculator state
        self.reset_state()
    
    def create_number_buttons(self):
        # Create number buttons 0-9
        self.number_buttons = {}
        for i in range(10):
            self.number_buttons[i] = QPushButton(str(i))
            self.number_buttons[i].clicked.connect(lambda checked, num=i: self.number_clicked(num))
            self.number_buttons[i].setStyleSheet("font-size: 18px; padding: 10px;")
        
        # Add number buttons to grid
        # Add 1-9
        positions = [(i, j) for i in range(3) for j in range(3)]
        for position, num in zip(positions, range(1, 10)):
            self.buttons_layout.addWidget(self.number_buttons[num], *position)
        
        # Add 0
        self.buttons_layout.addWidget(self.number_buttons[0], 3, 1)
        
        # Add decimal point
        self.decimal_button = QPushButton(".")
        self.decimal_button.clicked.connect(self.decimal_clicked)
        self.decimal_button.setStyleSheet("font-size: 18px; padding: 10px;")
        self.buttons_layout.addWidget(self.decimal_button, 3, 2)
    
    def create_operation_buttons(self):
        # Create operation buttons
        self.add_button = QPushButton("+")
        self.subtract_button = QPushButton("-")
        self.multiply_button = QPushButton("×")
        self.divide_button = QPushButton("÷")
        self.equals_button = QPushButton("=")
        self.clear_button = QPushButton("C")
        
        # Set button styles
        for button in [self.add_button, self.subtract_button, self.multiply_button,
                      self.divide_button, self.equals_button, self.clear_button]:
            button.setStyleSheet("font-size: 18px; padding: 10px; background-color: #f0f0f0;")
        
        self.equals_button.setStyleSheet("font-size: 18px; padding: 10px; background-color: #4CAF50; color: white;")
        self.clear_button.setStyleSheet("font-size: 18px; padding: 10px; background-color: #f44336; color: white;")
        
        # Connect button signals
        self.add_button.clicked.connect(lambda: self.operation_clicked("+"))
        self.subtract_button.clicked.connect(lambda: self.operation_clicked("-"))
        self.multiply_button.clicked.connect(lambda: self.operation_clicked("*"))
        self.divide_button.clicked.connect(lambda: self.operation_clicked("/"))
        self.equals_button.clicked.connect(self.equals_clicked)
        self.clear_button.clicked.connect(self.clear_clicked)
        
        # Add operation buttons to grid
        self.buttons_layout.addWidget(self.add_button, 0, 3)
        self.buttons_layout.addWidget(self.subtract_button, 1, 3)
        self.buttons_layout.addWidget(self.multiply_button, 2, 3)
        self.buttons_layout.addWidget(self.divide_button, 3, 3)
        self.buttons_layout.addWidget(self.equals_button, 3, 0)
        self.buttons_layout.addWidget(self.clear_button, 4, 0, 1, 4)
    
    def reset_state(self):
        self.current_input = "0"
        self.first_operand = None
        self.operation = None
        self.new_input = True
        self.update_display()
    
    def update_display(self):
        self.display.setText(self.current_input)
    
    def number_clicked(self, number):
        if self.new_input:
            self.current_input = str(number)
            self.new_input = False
        else:
            if self.current_input == "0":
                self.current_input = str(number)
            else:
                self.current_input += str(number)
        self.update_display()
    
    def decimal_clicked(self):
        if self.new_input:
            self.current_input = "0."
            self.new_input = False
        else:
            if "." not in self.current_input:
                self.current_input += "."
        self.update_display()
    
    def operation_clicked(self, op):
        if self.first_operand is not None and not self.new_input:
            self.equals_clicked()
        self.first_operand = float(self.current_input)
        self.operation = op
        self.new_input = True
    
    def equals_clicked(self):
        if self.operation is None or self.new_input:
            return
        
        second_operand = float(self.current_input)
        result = 0
        
        try:
            if self.operation == "+":
                result = self.first_operand + second_operand
            elif self.operation == "-":
                result = self.first_operand - second_operand
            elif self.operation == "*":
                result = self.first_operand * second_operand
            elif self.operation == "/":
                if second_operand == 0:
                    self.current_input = "Error"
                    self.update_display()
                    self.new_input = True
                    return
                result = self.first_operand / second_operand
            
            # Format the result
            if result == int(result):
                self.current_input = str(int(result))
            else:
                self.current_input = str(result)
            
            self.first_operand = None
            self.operation = None
            self.new_input = True
            self.update_display()
        
        except Exception as e:
            self.current_input = "Error"
            self.update_display()
            self.new_input = True
    
    def clear_clicked(self):
        self.reset_state()
    
    def run(self):
        self.window.show()
        return self.app.exec_()

def main():
    calculator = CalculatorApp()
    return calculator.run()

# Call the main function
if __name__ == "__main__":
    main()