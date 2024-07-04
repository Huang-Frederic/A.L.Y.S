import configparser
import os

from playwright.sync_api import sync_playwright


def fetch_html(url):
    config = configparser.ConfigParser()
    config.read("config.ini")
    timeout = config.getint("scraping", "fetch_timeout", fallback=60000)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(url, timeout=timeout)
        html = page.content()
        browser.close()
    return html
