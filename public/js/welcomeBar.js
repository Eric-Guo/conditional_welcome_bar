const { shop } = window.Shopify || {};
const apiHostname = 'conditionalwelcomebar.ngrok.io';
const shopDomain = shop.replace('.myshopify.com', '');

appendStylesheet(`https://${apiHostname}/css/welcomeBar.css`);

insertWelcomeBar();

fetchBar();

getCurrentTemplate();

function getCurrentTemplate() {
  const path = window.location.pathname;
  let template;

  if (path === '/') {
    template = 'homepage';
  } else if (path === '/cart') {
    template = 'cart';
  } else if (path.indexOf('/products/') !== -1) {
    template = 'product';
  } else if (path.indexOf('/collections/') !== -1) {
    template = 'collection';
  }

  return template;
}

function fetchBar() {
  const request = new XMLHttpRequest();

  request.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
      console.log(this.responseText);
    }
  };
  
  request.open('GET', `https://${apiHostname}/api/bars/${shopDomain}`);
  request.send();
}

function insertWelcomeBar() {
  const body = document.getElementsByTagName('body')[0];
  const bar = document.createElement('div');
  bar.classList.add('cw-bar');
  bar.innerHTML = 'WELCOME BAR HERE';
  body.insertBefore(bar, body.firstChild);
}

function appendStylesheet(hrefPathname) {
  const head = document.getElementsByTagName('head')[0];
  const link = document.createElement('link');
  link.rel = 'stylesheet';
  link.type = 'text/css';
  link.href = hrefPathname;

  head.appendChild(link);
}
