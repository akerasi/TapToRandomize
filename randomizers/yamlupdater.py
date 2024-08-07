import yaml
import configparser


def set_values(config, section):
    with open(config[section]["YAMLFilePath"]) as f:
        doc = yaml.load(f, Loader=yaml.FullLoader)
    for dict in doc:
        if (dict != "name") and (dict != "game") and (dict != "description"):
            docsection = dict
    for value in config.options(section):
        if value != "yamlfilepath":
            if config[section][value] == "null":
                    doc[docsection][value] = {}
            else:
                doc[docsection][value] = config[section][value]
    with open(config[section]["YAMLFilePath"], 'w') as f:
        yaml.dump(doc, f, default_flow_style=False)

def set_host(config):
    with open(config["basedirs"]["HostYamlPath"]) as f:
        doc = yaml.load(f, Loader=yaml.FullLoader)
    doc["general_options"]["output_path"] = config["basedirs"]["TmpDir"]
    doc["cv64_options"]["rom_file"] = config["cv64-a-yaml"]["rom_path"]
    doc["dkc3_options"]["rom_file"] = config["dkc3-a-yaml"]["rom_path"]    
    doc["lttp_options"]["rom_file"] = config["alttp-a-yaml"]["rom_path"]
    doc["lufia2ac_options"]["rom_file"] = config["l2ac-a-yaml"]["rom_path"]
    doc["mmbn3_options"]["rom_file"] = config["mmbn3-a-yaml"]["rom_path"]
    doc["pokemon_rb_options"]["blue_rom_file"] = config["pokerb-a-yaml"]["blue_rom_path"]
    doc["pokemon_rb_options"]["red_rom_file"] = config["pokerb-a-yaml"]["red_rom_path"]
    doc["sm_options"]["rom_file"] = config["sm-a-yaml"]["rom_path"]
    doc["smw_options"]["rom_file"] = config["smw-a-yaml"]["rom_path"]
    doc["soe_options"]["rom_file"] = config["soe-a-yaml"]["rom_path"]
    doc["tloz_options"]["rom_file"] = config["loz-a-yaml"]["rom_path"]
    doc["yoshisisland_options"]["rom_file"] = config["smw2-a-yaml"]["rom_path"]
    doc["yugioh06_settings"]["rom_file"] = config["ygo-a-yaml"]["rom_path"]
    doc["zillion_options"]["rom_file"] = config["zillion-a-yaml"]["rom_path"]
    with open(config["basedirs"]["HostYamlPath"], 'w') as f:
        yaml.dump(doc, f, default_flow_style=False)

def main():
    config = configparser.ConfigParser()
    config.read("randomizerlauncheryaml.ini")
    for section in config.sections():
        if section.endswith("yaml"):
            set_values(config, section)
    set_host(config)


if __name__=="__main__": 
    main() 