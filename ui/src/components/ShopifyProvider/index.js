import React from 'react';
import PropTypes from 'prop-types';
import { AppProvider } from '@shopify/polaris';
import shopOrigin from '../../util/shopifyUtil';
import { apiFetch } from '../../util/apiUtil';
import ShopifyLinkRouter from '../ShopifyLinkRouter';
import AlertsContextProvider from '../../contexts/AlertsContextProvider';
import ShopifyAppRouter from '../ShopifyAppRouter';
import SingleBarDestroyModal from '../SingleBarDestroyModal';
import ShopifyToast from '../ShopifyToast';

const ShopifyProvider = ({ children }) => {
  const { REACT_APP_SHOPIFY_API_CLIENT_KEY } = process.env;

  if (window.top === window.self) {
    const goToLogin = () => window.location.assign('/login');

    if (shopOrigin) {
      apiFetch(`shops/${shopOrigin}`).then((res) => {
        if (res.status === 'fail') {
          goToLogin();
        }
      });
    } else {
      goToLogin();
    }
  }

  return (
    <AppProvider
      apiKey={REACT_APP_SHOPIFY_API_CLIENT_KEY}
      shopOrigin={shopOrigin}
      linkComponent={ShopifyLinkRouter}
      forceRedirect
    >
      <AlertsContextProvider>
        <ShopifyAppRouter />
        <SingleBarDestroyModal />
        {children}
        <ShopifyToast />
      </AlertsContextProvider>
    </AppProvider>
  );
};

ShopifyProvider.propTypes = {
  children: PropTypes.node.isRequired,
};

export default ShopifyProvider;