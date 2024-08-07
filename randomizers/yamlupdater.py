import yaml
import configparser


def set_values(config, section, file_name):
    with open(file_name) as f:
        doc = yaml.safe_load(f)
    for dict in doc:
        if (dict != "name") and (dict != "game") and (dict != "description"):
            docsection = dict
    for value in config.options(section):
        if value != "yamlfilepath":
           doc[docsection][value] = config[section][value]
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