import React from 'react';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';

const styles = theme => ({
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    width: 250,
  },
})


class AppName extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    title: PropTypes.string,
    newAppName: PropTypes.string,
    onHandleChange: PropTypes.func,
    isCorrectInput: PropTypes.bool
  }

  render() {
    const {
      classes,
      title,
      newAppName,
      onHandleChange,
      isCorrectInput
    } = this.props;

    return (
      <React.Fragment>
        <Typography variant="h5" gutterBottom align="center">
          {title}
        </Typography>
        <Grid
          container
          direction="row"
          justify="space-evenly"
          alignItems="center"
        >
          <Grid item>
            <TextField
              id="new-app-name"
              label="New Application"
              className={classes.textField}
              value={newAppName}
              onChange={onHandleChange("newAppName")}
              margin="normal"
              error={!isCorrectInput}
              helperText={
                isCorrectInput
                ? ""
                :"invalid application name"
              }
            />
          </Grid>
        </Grid>
      </React.Fragment>
    )
  }
}

export default withStyles(styles)(AppName)