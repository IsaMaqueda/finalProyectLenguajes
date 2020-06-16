# Exploratory Statistics in Racket of Number of car crashes in Mexico City
For the Final project,  we want to write a program in Racket that can open a .csv file, read its contents and process the data inside.
The program recieves a csv file, reads it line per line, chooses only one column and stores it in a list. From that list, the program then sorts the list so it is in order, and then gets how many different elements are in the list and counts it. The variables will be processed to get statistics that will broadly indicate the distribution of the set (expected value, median, mode, standard deviation of the set, etc..). In our program we will also implement some algorithms to generate prediction models, particularly linear and polynomial regression, of the variables. 

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites
With these instructions we assusme you are using UBUNTU Linux
You will need to install git and racket
``` 
sudo apt instal git 
```
``` 
sudo apt instal racket
```
### Install
A step by step instructions to run the proyect

Install git

``` 
sudo apt instal git
```
Install racket
``` 
sudo add-apt-repository ppa:plt/racket
```
``` 
sudo apt-get update
```
``` 
sudo apt-get install racket
```

And to run 
``` 
racket
```
``` 
(enter! "Proyect5.rkt")
```
and choose which functions to call.

## Running the tests
Move to the folder
To run the tests you first

### Run the program

To use the program we use 
``` 
(enter! "Proyect5.rkt")
```

``` 
!!!!!! aqui va la unica funcion que usamos para llamar el programa
```

## Functions 
* **element-in** gets as arguments a list and a number. Returns the element in the list in the position of the number
  *   ``` 
      (element-in '(1 2 3 4 5 6 7 8) 4)
      ```
  * [Image of function](images/element.jpeg)
      
* **split**  gets a line from a csv as an argument. The function separates the elements by the "," and returns it as a list
  * ``` 
      (split "la,moronja,esta,provando,la,funcion")
      ```
* **get-list**  gets as an argument a file and a number. The file is the name of the file we have to use and the number is the number of the column we want to use. It returns a list that first uses column-maker to change the csv file  column to a list. Then it uses count-different to count the number of different elements are in the list and then count the number instances each element has. It returns a list that has the numebr of different elements and it's count
  * ``` 
      (get-list 3 "ejemplo.csv")
      ```
* **count-different** gets a list as an argument. From the list it gets the different elements of the list and counts the number of time that element appeared on the list.
  * ``` 
      (count-different '("1" "2" "3" "4" "1" "2" "3" "1" "2" "3" "4"))
      ```
* **column-maker** gets as an argument a number and the name of a csv file. The function reads the file line per line. In each line it sends for split to create a list from the line, then it sends the list with the number to look up the element of that list that is in.
  * ``` 
      (column-maker 3 "ejemplo.csv")
      ```
 * **get-average** gets as an argument a number and the name of a csv file. The function gets a list get-list and returns the average of each element of the file divided by 7, that are the number of the years the file has. 
   * ``` 
      (get-averager 3 "ejemplo.csv")
      ```

## Description of the program
The program recieves a csv file, gets a column from the file, gets the diferent elements that are in that column and counts the numebr of instances each element has in that column. Then

## Topics Used 
 * **FILE INPUT** In order to read the .csv file, we need to use file input
 * **FUNCTIONAL PROGRAMMING** The data we obtain from the csv files is going to be immutable throughout all our analysis and be processed solely with functions and lambda functions. 
 * **LISTS** The columns of data will be stored in lists and manipulated as lists.
 * **RECURSION** Since the data is stored in lists our functions will be recursive, to be able to process each element.


## Requirements
You need to use ubuntu or DrRacket in Windows. 

## Built With
* [Ubuntu](https://ubuntu.com/) - the operating system
* [Visual Studio Code](https://code.visualstudio.com/) - Text Editor
* [Racket](https://racket-lang.org/) - Text Editor


## Authors
* **Isabel Maqueda Rolon A01652906**
* **Eduardo Badillo Alvarez A0102**


## License
This project is licensed under the TEC License

## Acknowledgments
* [Guillermo Echeverria](https://github.com/gilecheverria) - The Instuctor and Profesor 
