import { Fragment } from 'inferno';
import { act } from '../byond';
import { Button, LabeledList, NoticeBox, Section, Box } from '../components';

export const Vending = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  return (
    <Fragment>
      {data.currently_vending_name ? (
        <NoticeBox>
          You have selected {data.currently_vending_name}.<br/>
          Please swipe your ID to pay for the article.<br/>
          <Button
            onClick={() => act(ref, 'cancel_buying')}>Cancel</Button>
        </NoticeBox>
      ) : (
        <Fragment>
          {(data.premium_length > 0 || data.isshared ) &&
            (<Box inline>Coin slot: </Box>)+data.coin ? (
            <Button
              onClick={() => act(ref, 'remove_coin')}>Remove</Button>)
            : ('No coin inserted')
          }
        </Fragment>
      )}
      <Section label="Select an item:">
        {data.displayed_records.length > 0 ? (
        <LabeledList>
          {data.displayed_records.map(display_record => (
            <LabeledList.Item>
              <Button
                color={display_record.prod_color}
                onClick={() => act(ref, 'vend', {vend: display_record.prod_index, cat: display_record.prod_cat})}
                disabled={!display_record.amount}>
                {display_record.prod_name}
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
        ) : (
          <Box color="red">No product loaded!</Box>
        )}
      </Section>
    </Fragment>)};
