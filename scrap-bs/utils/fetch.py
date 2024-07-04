import configparser

from playwright.sync_api import sync_playwright


def fetch_html(url):
    # Load the configuration from the config.ini file
    config = configparser.ConfigParser()
    config.read("config.ini")
    timeout = config.getint("scraping", "fetch_timeout", fallback=60000)

    # Fetch the HTML content of the given URL
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(url, timeout=timeout)
        html = page.content()
        browser.close()
    return html
