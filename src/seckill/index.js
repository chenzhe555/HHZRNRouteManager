import React from 'react';
import { View, Text, Image } from 'react-native';
import Toast from 'react-native-cz-toast';

export default class SeckillMainVC extends React.Component {
    constructor(props) {
        super(props);
        console.log('加载了 秒杀页 333 ...');
    }

    _clicked = () => {
      Toast.show('显示Toast')
  }

  render() {
    return (
      <View style={{ marginTop: 100 }}>
        <Text onPress={this._clicked}>SeckillMainVC(点击)-5 d</Text>
      </View>
    )
  }
}
