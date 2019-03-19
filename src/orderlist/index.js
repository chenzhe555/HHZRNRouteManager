import React from 'react';
import { View, Text, Image } from 'react-native';
import ImagePlaceholder from 'react-native-cz-image-placeholder';

export default class OrderListMainVC extends React.Component {
    constructor(props) {
        super(props);
        console.log('加载了 订单列表 222 ...');
    }

    render() {
    return (
      <View style={{ marginTop: 100 }}>
        <Text>OrderListMainVC-2</Text>
        <ImagePlaceholder
          width={200}
          height={200}
          url={
            'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1552632483&di=d61ca696a8710229ead2fcb530d3bff0&src=http://img3.duitang.com/uploads/blog/201504/03/20150403235853_ZtrsW.thumb.700_0.jpeg'
          }
        />
      </View>
    )
  }
}
