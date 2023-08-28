"""
Simply makes UsefulLife an int.
"""
import argparse
import logging
from lxml import etree as ET


logging.basicConfig(level=logging.INFO)


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("from_file", type=str, help="path to file to update")
    parser.add_argument(
        "--to_file",
        type=str,
        help="path to write update to",
        required=False,
        default=None,
    )
    return parser.parse_args()


def update_version(tree):
    tree.getroot().set("version", "2.5.0")


def update_usefulLife(tree):
    for usefulLife in tree.findall(
        ".//*{http://buildingsync.net/schemas/bedes-auc/2019}UsefulLife"
    ):
        new_value = str(round(float(usefulLife.text)))
        if new_value != usefulLife.text:
            logging.info(
                f"changing {tree.getelementpath(usefulLife)} value from {usefulLife.text} to {new_value}"
            )
            usefulLife.text = new_value


def main():
    from_file, to_file = get_args().from_file, get_args().to_file

    try:
        tree = ET.parse(from_file)
    except (FileNotFoundError, ET.ParseError) as e:
        exit(f"File could not be read \n{e} \naborting...")

    update_version(tree)
    update_usefulLife(tree)

    if to_file is None:
        to_file = from_file

    tree.write(to_file)


if __name__ == "__main__":
    main()
