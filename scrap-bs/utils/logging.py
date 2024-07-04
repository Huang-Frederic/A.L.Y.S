import configparser
import os
from datetime import datetime


class Logger:
    LOGS_DIR = "logs"

    def __init__(self):
        # Initialization
        self.init_logging()
        self.timestamp = datetime.now().strftime("%Y-%m-%d %H-%M-%S")
        self.load_config()

    def init_logging(self):
        # Create logs directory if it doesn't exist
        os.makedirs(self.LOGS_DIR, exist_ok=True)

        # Open the log file for appending
        log_file_name = datetime.now().strftime("%Y-%m-%d_%H-%M.log")
        log_file_path = os.path.join(self.LOGS_DIR, log_file_name)
        self.log_file = open(log_file_path, "a", encoding="utf-8")

    def load_config(self):
        config = configparser.ConfigParser()
        config.read("config.ini")
        self.show_debug_logs = config.getboolean(
            "logging", "show_debug_logs", fallback=True
        )

    # Log messages with different log levels
    def log(self, message, log_level="INFO"):
        if self.log_file:
            log_line = f"[{log_level}] {message}\n"
            self.log_file.write(log_line)  # Write to log file
            if log_level != "DEBUG" or self.show_debug_logs:
                self.print_colored(log_line, log_level)  # Print to console with color
        else:
            self.print_colored("Error: Log file not open for writing.", "ERROR")

    # Print messages with different colors based on log level
    def print_colored(self, message, log_level):
        if log_level == "INFO":
            print(f"\033[96m{message}\033[0m")  # Cyan text for global information
        elif log_level == "ERROR":
            print(f"\033[91m{message}\033[0m")  # Red text for errors
            self.close()
        elif log_level == "SUCCESS":
            print(f"\033[92m{message}\033[0m")  # Green text for success
        elif log_level == "DEBUG" and self.show_debug_logs:
            print(f"\033[95m{message}\033[0m")  # Light violet text for debug
        elif log_level == "STATE":
            print(f"\033[93m{message}\033[0m")  # Yellow text for announcements

    def close(self):
        if self.log_file:
            self.log_file.close()
