import yaml
import configparser


def set_values(config, section, file_name):
    with open(file_name) as f:
        doc = yaml.safe_load(f)
    for value in config.options(section):
        if value != "YAMLFilePath":
           doc[value] = config[section][value]
    with open(file_name, 'w') as f:
        yaml.safe_dump(doc, f, default_flow_style=False)

def main():
    config = configparser.ConfigParser()
    config.read("randomizerlauncher.ini")
    for section in config.sections():
        if section.endswith("yaml"):
            set_values(config, section, config[section]["YAMLFilePath"])



if __name__=="__main__": 
    main() 