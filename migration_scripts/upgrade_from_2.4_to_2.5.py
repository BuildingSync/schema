"""
Simply makes UsefulLife an int.
"""

import argparse
import logging
import sys

from lxml import etree

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
    root = tree.getroot()

    root.set("version", "2.5.0")
    root.insert(
        0,
        etree.Comment(
            "This BuildingSync v2.5 document was generated from a BuildingSync v2.4 document via the BuildingSync migration scripts",
        ),
    )


def update_useful_life(tree):
    for useful_life in tree.findall(
        ".//*{http://buildingsync.net/schemas/bedes-auc/2019}UsefulLife",
    ):
        new_value = str(round(float(useful_life.text)))
        if new_value != useful_life.text:
            logging.info(
                f"changing {tree.getelementpath(useful_life)} value from {useful_life.text} to {new_value}",
            )
            useful_life.text = new_value


def main():
    from_file, to_file = get_args().from_file, get_args().to_file

    try:
        tree = etree.parse(from_file)  # noqa: S320
    except (FileNotFoundError, etree.ParseError) as e:
        sys.exit(f"File could not be read \n{e} \naborting...")

    update_version(tree)
    update_useful_life(tree)

    if to_file is None:
        to_file = from_file

    tree.write(to_file)


if __name__ == "__main__":
    main()
