import React, { Component } from "react";
import { Card, Message, Button } from "semantic-ui-react";
import Layout from "../../components/layoutlogout";
import User1 from '../../ethereum/user';
import factory from '../../ethereum/factory_user'
import { Link } from "../../routes";

class UserDetails extends Component {

  state={
    fname:"",
    lname:"",
    phone:"",
    adhaar:"",
    email:"",
    eth:"",
    errorMessage: ""
  }

  static async getInitialProps(props) {
    //call api
    const add=props.query.address;
    return { add };
  }

  async componentDidMount() {

    try{
      const addr = await factory.methods.getstoreaddress(this.props.add).call();
      
      console.log(addr);
      const user1= User1(addr);
      const summary = await user1.methods.showdetails().call();
      console.log(summary);

      this.setState({fname:summary[0],lname:summary[1],phone:summary[2],adhaar:summary[3],eth:summary[4],email:summary[5]});

    }catch(err){
      this.setState({ errorMessage: err.message });
    }
  }

  renderCampaigns() {
    //replace data here
    const items = [
      {
        header: "First Name",
        description: this.state.fname,
      },
      {
        header: "Last Name",
        description: this.state.lname,
      },
      {
        header: "Phone Number",
        description: this.state.phone,
      },
      {
        header: "Adhaar Number",
        description: this.state.adhaar,
      },
      {
        header: "Email",
        description: this.state.email,
      },
    ];

    return <Card.Group items={items} />;
  }

  render() {
    return (
      <Layout>
        <div>
          <h3>User Details for address {this.props.add}</h3>

          {this.renderCampaigns()}

          {this.state.errorMessage && <Message error header="Oops!" content={this.state.errorMessage} />}

          
        </div>
      </Layout>
    );
  }
}

export default UserDetails;