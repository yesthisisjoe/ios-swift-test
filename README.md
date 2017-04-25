AlayaCare iOS Swift skill test
===============================


### What's included
The repo contains a skeleton iOS application created using XCode 8.3.2. The app contains:
* NoteController: An empty activity to display a list of notes. 
* NoteModel: An empty data model to represent a note entity. 
* Main.storyboard: A storyboard containing an empty view for the note controller

### Requirements
* XCode 8+
* A github account

### Installation
* Fork this repository
* Open the directory in XCode 8
* The app should build and run if all requirements are met

### Instructions
The goal of this exercise is to create a very simple note app by following the tasks below. 
Code should be clear, easy to read, and modular. 

* TASK 1: Create a data source for the notes:
  * Add non-null `text` and non-null `date` fields to the note model
  * Create a mock API to return a list of fake notes asynchronously

* TASK 2: Display a table of notes in the note controller:
  * use the mock API to populate the list
  * each list item should display the note text and date

* Task 3: Implement logic for creating a new note:
  * do this however you want
  * storage can be in memory 
  * note text should not be empty
  * new notes should appear in the note controller

* Task 4: Add search functionality to your list of notes:
  * search should support matching to any part of the note text

* OPTIONAL Task 5: Save and delete notes
  * use CoreData to persist the notes
  * remove your mock API and save new notes to CoreData
  * add an option to delete a note from the list
