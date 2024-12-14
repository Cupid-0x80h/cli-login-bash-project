# Test System Shell Script

A simple shell script-based test system that allows users to sign up, sign in, take a timed test, view test results, and track user activities. This script is intended for use on Linux systems.

## Features

- **User Authentication:**
  - **Sign Up:** Users can register with a username and password (password requirements: minimum 8 characters, including at least one number and one symbol).
  - **Sign In:** Registered users can log in using their credentials.

- **Test Functionality:**
  - Users can take a multiple-choice test with randomly selected questions.
  - Each question has a time limit (10 seconds).
  - The user's answers and the time taken to answer are recorded.

- **Test Results:**
  - Users can view their test results, including the questions, answers, and the time it took to answer each question.

- **Logging & Backup:**
  - All user activities (e.g., sign-in attempts, test submissions) are logged in a file (`test_activity.log`).
  - Answer files are backed up before being overwritten.

- **Timeout Mechanism:**
  - The main menu and question prompts have a timeout feature (10 seconds).
  - If no input is given within the time frame, the script moves to the next prompt.

## Requirements

- Linux system with Bash support
- A terminal to execute the script
- A file containing the question bank (default: `question_bank.txt`)
- Permissions to create directories and write to files (e.g., `.TestData`)

## Usage

### 1. **Sign Up**

To register a new user:
- The username should only contain alphanumeric characters.
- The password must be at least 8 characters long, contain at least one number, and one special symbol.
- After providing the details, you must confirm the password by entering it again.

### 2. **Sign In**

To log in:
- Enter your registered username and password.
- If the credentials are correct, you will proceed to the test menu.

### 3. **Take a Test**

Once signed in, you can take the test:
- The questions will be picked randomly from the `question_bank.txt` file.
- Each question is followed by multiple-choice options.
- You must answer within 10 seconds for each question.
- Your answers and the time taken to respond will be saved in a CSV file (`answer_file.csv`).

### 4. **View Test Results**

You can view your previous test results:
- Each question, your answer, and the time you took to respond will be displayed.

### 5. **Exit**

You can exit the script at any time by selecting the "Exit" option from the main menu.

## Files

- `login.sh`: The main script for the test system.
- `question_bank.txt`: A text file containing questions for the test (can be user-provided or the script will search for this file).
- `test_activity.log`: A log file where all user activities are recorded (e.g., sign-ins, test attempts).
- `TestData/answer_file.csv`: A CSV file where answers to the test are stored with timestamps.

## Installation

1. **Clone the repository:**

   ```bash
   https://github.com/Cupid-0x80h/cli-login-bash-project.git
   cd cli-login-bash-project
   
2. **Make the script executable:**

   ```bash
   chmod +x login.sh
3. **Run the script**
   
   ```bash
   ./login.sh

## Notes

### Question Bank File:
- The script will look for a file named `question_bank.txt` in the current directory. If it's not provided, you will need to create and format this file. The questions should be listed, one per line.

### Log Files and Answer Files:
- The `test_activity.log` and `answer_file.csv` will be created in the current directory (or within the user’s home directory if needed).

### Timeouts:
- The script times out if no input is provided within 10 seconds on the main menu and for answering each question.
## Contributing

If you would like to contribute to this project, feel free to fork the repository, make changes, and submit a pull request. Any contributions to improve the script or add new features are welcome!

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

## Author

Cupid-0x80H

## GitHub

[Cupid-0x80H](https://github.com/Cupid-0x80h/)

  
