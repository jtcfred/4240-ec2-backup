#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <filesystem>
#include <unordered_map>
#include <sstream>

void configure();
void listBackups();
void getBackup(const char *);
void start();
void backup();
void stop();
bool checkIfUserHasCrontab();
void printHelp();

std::unordered_map<std::string, std::string> configValues;

void populateConfigValues()
{
    const char *homeDir = std::getenv("HOME");
    if (homeDir == nullptr)
    {
        std::cerr << "Error: HOME environment variable not set." << std::endl;
        return;
    }
    std::string filePath = std::string(homeDir) + "/.cloud-config.conf";

    // Open the configuration file
    std::ifstream configFile(filePath);

    // Check if the file is open
    if (!configFile.is_open())
    {
        std::cerr << "Error: Unable to open the configuration file, or no config exists... Run cloud-backup configure first." << std::endl;
        exit(1);
    }

    // Read the file line by line
    std::string line;
    while (std::getline(configFile, line))
    {
        // Use a stringstream to parse the line
        std::istringstream iss(line);

        // Extract the key and value
        std::string key, value;
        if (std::getline(iss, key, '=') && std::getline(iss, value))
        {
            // Remove leading and trailing whitespaces from the key and value
            key.erase(0, key.find_first_not_of(" \t"));
            key.erase(key.find_last_not_of(" \t") + 1);

            value.erase(0, value.find_first_not_of(" \t"));
            value.erase(value.find_last_not_of(" \t") + 1);

            // Remove double quotations around the value
            if (!value.empty() && value.front() == '"' && value.back() == '"')
            {
                value = value.substr(1, value.size() - 2);
            }

            // Store the key-value pair in the global map
            configValues[key] = value;
        }
    }

    // Close the configuration file
    configFile.close();
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cout << "Usage: " << argv[0] << " <command> [options]\n";
        return 1;
    }

    std::string command = argv[1];

    if (command == "configure")
    {
        configure();
    }
    else if (command == "start")
    {
        start();
    }
    else if (command == "stop")
    {
        stop();
    }
    else if (command == "backup")
    {
        backup();
    }
    else if (command == "list")
    {
        listBackups();
    }
    else if (command == "help")
    {
        printHelp();
    }
    else if (command == "get")
    {
        if (argc < 3)
        {
            std::cout << "Usage: " << argv[0] << " get <fileName>\n";
            return 1;
        }
        getBackup(argv[2]);
    }
    else
    {
        std::cout << "Unknown command: " << command << ". Run \"cloud-backup help\" for a list of available commands \n";
        return 1;
    }

    return 0;
}

bool checkIfUserHasCrontab()
{
    const std::string command = "crontab -l";
    FILE *pipe = popen(command.c_str(), "r");
    if (!pipe)
    {
        std::cerr << "Error: Unable to execute command" << std::endl;
        exit(1);
    }

    char buffer[128];
    std::string result;
    while (fgets(buffer, sizeof(buffer), pipe) != nullptr)
    {
        result += buffer;
    }
    pclose(pipe);
    if (result.find("no crontab") != std::string::npos)
    {
        return false;
    }
    else
    {
        return true;
    }
}

void start()
{
    bool userHasCronTab = false;

    populateConfigValues();
    if (configValues["BACKUP_FREQ"].length() <= 1)
    {
        std::cout << "Error: Backup frequency not set. Set it in ~/.cloud-config.conf." << std::endl;
        return;
    }
    const std::string cronCommand = "crontab -l | { echo '" + configValues["BACKUP_FREQ"] + " " + configValues["INSTALL_PATH"] + "/backup.sh'; } | crontab -";
    std::cout << "Starting backup process..." << std::endl;
    system(cronCommand.c_str());
    return;
}

void stop()
{
    populateConfigValues();
    const std::string cronCommand = "crontab -l | grep -v \"" + configValues["INSTALL_PATH"] + "/backup.sh\" | crontab -";
    std::cout << "Stopping backup process..." << std::endl;
    system(cronCommand.c_str());
    return;
}

void backup()
{
    populateConfigValues();
    const std::string command = configValues["INSTALL_PATH"] + "/backup.sh";
    std::cout << command << std::endl;
    system(command.c_str());
    return;
}

void configure()
{
    // Get file path to config
    const char *homeDir = std::getenv("HOME");
    if (homeDir == nullptr)
    {
        std::cerr << "Error: HOME environment variable not set." << std::endl;
        return;
    }
    std::string filePath = std::string(homeDir) + "/.cloud-config.conf";

    std::ifstream file(filePath.c_str());
    if (file.good())
    {
        std::cout << "Config already exists. Edit it at ~/.cloud-config.config." << std::endl;
        return;
    }
    else
    {
        std::ofstream outFile(filePath.c_str());
        if (!outFile.is_open())
        {
            std::cerr << "Error: Could not create config file" << std::endl;
            return;
        }
        std::string sourceDir, destUser, hostServer, keyFile, destDir, backupFrequency;
        std::cout << "Backup source directory: ";
        std::getline(std::cin, sourceDir);
        std::cout << "EC2 User: ";
        std::getline(std::cin, destUser);
        std::cout << "EC2 Endpoint: ";
        std::getline(std::cin, hostServer);
        std::cout << "Key file: ";
        std::getline(std::cin, keyFile);
        std::cout << "Destination directory: ";
        std::getline(std::cin, destDir);
        std::cout << "Backup frequency (in cron format): ";
        std::getline(std::cin, backupFrequency);

        outFile << "CURRENT_USER=$(whoami)\n";
        outFile << "SOURCE_DIR=\"" << sourceDir << "\"\n";
        outFile << "DEST_USER=\"" << destUser << "\"\n";
        outFile << "HOST_SERVER=\"" << hostServer << "\"\n";
        outFile << "DEST_DIR=\"" << destDir << "\"\n";
        outFile << "PEM_FILE=\"" << keyFile << "\"\n";
        outFile << "BACKUP_FREQ=\"" << backupFrequency << "\"\n";
        outFile << "INSTALL_PATH=\"" << std::filesystem::current_path() << "\"\n";

        outFile.close();
    }
}

void listBackups()
{
    populateConfigValues();
    std::cout << "Listing available backups...\n";
    const std::string command = configValues["INSTALL_PATH"] + "/list_backup.sh";
    system(command.c_str());
}

void getBackup(const char *fileName)
{
    populateConfigValues();
    std::cout << "Retrieving backup " << fileName << "...\n";
    const std::string command = configValues["INSTALL_PATH"] + "/pull_backup.sh " + fileName;
    system(command.c_str());
}

void printHelp()
{
    std::cout << "cloud-backup - Command Line Tool for Cloud Backups\n\n";
    std::cout << "Usage:\n";
    std::cout << "  cloud-backup configure   - Configure the tool\n";
    std::cout << "  cloud-backup start       - Starts automatic backups\n";
    std::cout << "  cloud-backup stop        - Stops automatic backups\n";
    std::cout << "  cloud-backup list        - Lists all backups\n";
    std::cout << "  cloud-backup get <file>  - Gets a specific backup\n\n";
}