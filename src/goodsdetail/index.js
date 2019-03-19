import React from 'react';
import { View, Text, Image } from 'react-native';

export default class GoodsDetailMainVC extends React.Component {
  constructor(props) {
    super(props);
    console.log('加载了 商品详情 111 ...');
  }

  render() {
    return (
      <View style={{ marginTop: 100 }}>
        <Text>GoodsDetailMainVC-2</Text>
        <Image source={require("@images/phone.png")} style={[{width: 36, height: 36}]}/>
      </View>
    )
  }
}
