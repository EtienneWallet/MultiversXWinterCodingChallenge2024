"""
This module contains python functions that will be used by MxOps for the challenge #03
"""

from typing import List

from mxops.utils.wallets import generate_pem_wallet


def generate_random_addresses(n: int) -> List[str]:
    """
    Generate random addresses for the MultiversX network and return them

    :param n: num of addresses to generate
    :type n: int
    :return: generated addresses
    :rtype: List[str]
    """
    addresses = []
    for _ in range(n):
        _, address = generate_pem_wallet()
        addresses.append(address.to_bech32())
    return addresses
