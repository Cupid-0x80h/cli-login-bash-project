#!/bin/bash
# The file names
USER_CREDENTIALS_FILE=".user_credentials.csv"
LOG_FILE="test_activity.log"
ANSWER_FILE="TestData/answer_file.csv"
QUESTION_BANK_FILE="question_bank.txt"
TIMEOUT=10  # Timeout period in seconds

# The file paths       
USER_DIR="$HOME"
TEST_DATA_DIR="$USER_DIR/.TestData"

# The globals
USER_ID=""
USER_PASSWORD=""
QUESTION_BANK=()

# Function to log activities
function log() {
    local activity=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $activity" >> $LOG_FILE
}

# Function to create answer csv file if not exist
function answer_file_creation() {
    if [ ! -d "$TEST_DATA_DIR" ]; then
        mkdir -p "$TEST_DATA_DIR"
        log "Created directory $TEST_DATA_DIR"
    fi

    if [ ! -f "$ANSWER_FILE" ]; then
        touch "$ANSWER_FILE"
        log "Created answer file: $ANSWER_FILE"
    else
        # Backup existing answer file
        mv "$ANSWER_FILE" "$ANSWER_FILE.bak"
        touch "$ANSWER_FILE"
        log "Backup created for answer file, and new answer file created"
    fi
}

# Function to print the welcome menu
function menu_header() {
    clear
    echo "----------------------------"
    echo " Welcome to the Test System"
    echo "----------------------------"
    echo "1. Sign In"
    echo "2. Sign Up"
    echo "3. Exit"
    echo "----------------------------"
    echo -n "Please select an option: "
}

# Function to view the test screen (view results)
function view_test_screen() {
    echo "----------------------------"
    echo " Test Results"
    echo "----------------------------"
    if [ ! -f "$ANSWER_FILE" ]; then
        echo "No test taken yet!"
        return
    fi

    while IFS=, read -r question answer time; do
        echo "Q: $question"
        echo "A: $answer (Time: $time sec)"
        echo "----------------------------"
    done < "$ANSWER_FILE"
    log "Viewed the test results"
}

# Function to conduct the test
function test_screen() {
    local question
    local answer
    local answer_time

    # Read all questions from the question bank
    mapfile -t QUESTION_BANK < "$QUESTION_BANK_FILE"

    # Randomly pick questions and ask
    for question in "${QUESTION_BANK[@]}"; do
        echo "Question: $question"
        echo "Options: 1) Option A  2) Option B  3) Option C  4) Option D"
        echo -n "Please select your answer (1-4): "

        # Start timer for timeout
        start_time=$(date +%s)

        # Wait for user input or timeout
        read -t $TIMEOUT answer
        end_time=$(date +%s)
        answer_time=$((end_time - start_time))

        if [ -z "$answer" ]; then
            echo "Time's up! No answer provided."
            answer="No Answer"
            answer_time=$TIMEOUT
        fi

        echo "$question,$answer,$answer_time" >> "$ANSWER_FILE"
        log "Answered question '$question' with answer '$answer' in $answer_time seconds"
    done
}

# Function for the main test menu
function test_menu() {
    clear
    echo "----------------------------"
    echo " Test Menu"
    echo "----------------------------"
    echo "1. Take Test"
    echo "2. View Test Results"
    echo "3. Back to Main Menu"
    echo -n "Please select an option: "
    read test_option

    case $test_option in
        1) test_screen ;;
        2) view_test_screen ;;
        3) return ;;
        *) echo "Invalid option, try again!" ;;
    esac
}

# Function to handle sign-in
function sign_in() {
    echo -n "Enter User ID: "
    read sign_in_id
    echo -n "Enter Password: "
    read -s sign_in_password
    echo

    # Check if user exists in the credentials file
    user_found=0
    while IFS=, read -r user_id password; do
        if [ "$user_id" == "$sign_in_id" ] && [ "$password" == "$sign_in_password" ]; then
            user_found=1
            break
        fi
    done < "$USER_CREDENTIALS_FILE"

    if [ $user_found -eq 1 ]; then
        log "User signed in: $sign_in_id"
        USER_ID=$sign_in_id
        test_menu
    else
        echo "Invalid credentials! Please try again."
        log "Failed sign-in attempt for user $sign_in_id"
    fi
}

# Function to handle sign-up
function sign_up() {
    echo -n "Enter New User ID: "
    read sign_up_id
    echo -n "Enter New Password (min 8 chars, at least one number and symbol): "
    read -s sign_up_password
    echo
    echo -n "Re-enter Password: "
    read -s confirm_password
    echo

    if [[ ! "$sign_up_id" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "User ID should contain only alphanumeric characters!"
        return
    fi

    if [[ ! "$sign_up_password" =~ [0-9] ]] || [[ ! "$sign_up_password" =~ [[:punct:]] ]] || [[ ${#sign_up_password} -lt 8 ]]; then
        echo "Password must contain at least 8 characters, one number, and one symbol!"
        return
    fi

    if [ "$sign_up_password" != "$confirm_password" ]; then
        echo "Passwords do not match!"
        return
    fi

    # Check if the user already exists
    if grep -q "$sign_up_id" "$USER_CREDENTIALS_FILE"; then
        echo "User ID already exists! Please choose a different ID."
        return
    fi

    # Add new user to the credentials file
    echo "$sign_up_id,$sign_up_password" >> "$USER_CREDENTIALS_FILE"
    log "New user signed up: $sign_up_id"
    echo "Sign-up successful! Please sign in to proceed."
}

# Main Script Execution
answer_file_creation

# Creating user credentials file if it doesn't exist
if [ ! -f "$USER_CREDENTIALS_FILE" ]; then
    touch "$USER_CREDENTIALS_FILE"
    log "Created new user credentials file"
fi

# Main loop for the script
while true; do
    menu_header
    read user_choice

    case $user_choice in
        1) sign_in ;;
        2) sign_up ;;
        3) exit 0 ;;
        *) echo "Invalid choice. Please select a valid option!" ;;
    esac
done