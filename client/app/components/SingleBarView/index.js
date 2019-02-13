import React from 'react';
import PropTypes from 'prop-types';
import SingleBarForm from '../SingleBarForm';
import { apiFetch } from '../../../util/apiUtil';

class SingleBarView extends React.Component {
  state = { bar: {}, isLoading: true };

  componentDidMount() {
    const { match: { params } } = this.props;

    console.log(params);

    apiFetch(`/bars/${params.barId}`).then((bar) => this.setState({ bar }));
  }

  render() {
    const { history } = this.props;
    const { bar } = this.state;

    const breadcrumbs = [{
      content: 'Welcome Bars',
      onAction: () => history.push('/'),
    }];

    console.log('RENDER', bar);

    if (!bar.id) {
      return null;
    }

    return <SingleBarForm bar={bar} breadcrumbs={breadcrumbs} />;
  }
}

SingleBarView.propTypes = {
  match: PropTypes.instanceOf(Object),
  history: PropTypes.instanceOf(Object),
};

export default SingleBarView;
