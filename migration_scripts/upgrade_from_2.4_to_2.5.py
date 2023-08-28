"""
Simply makes UsefulLife an int.
"""
import argparse
from lxml import etree as ET

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("file_path", type=str, help="path to file to update")
    return parser.parse_args()

def update_usefulLife(tree):
    for usefulLife in tree.findall('.//*{http://buildingsync.net/schemas/bedes-auc/2019}UsefulLife'):
        usefulLife.text = usefulLife.text.split(".", 1)[0]

def main():
    file_path = get_args().file_path

    try:
        tree = ET.parse(file_path)
    except (FileNotFoundError, ET.ParseError) as e:
        exit(f"File could not be read \n{e} \naborting...")

    update_usefulLife(tree)
    
    tree.write(file_path)


if __name__ == "__main__":
    main()
