local merchant = {}

merchant.shop_sign = string.format('Shop managed by %s', _VERSION)

merchant.items = { 
  {name = 'Pot', cost = 3}, 
  {name = 'Turret Seed', cost = 10}, 
  {name = 'Bomb Seed', cost = 1},   
  {name = 'Bomb Shroom', cost = 5} 
}

-- increases whenever the merchant sells something
merchant.gold = 0

function merchant:begin_play()
  self.flash(merchant.shop_sign)
end

function merchant:begin_overlap(other)
  if get_player() == other then
    self.flash('Buy something')
    current_target = self.owner
  end
end

function merchant:end_overlap(other)
  if get_player() == other then
    self.flash(merchant.shop_sign)
    current_target = nil
  end
end

function merchant:speak()

  -- reset when closing the shop
  function close()
    self.set_camera(get_player())
    close_dialogue()
  end

  -- special closure for generating a callback with the index of the item to buy
  local function buy(index)
    return function()
        -- Validate the item before processing
        local item = merchant.items[index]
        if not item then
            open_dialogue('This item no longer exists.', {{'Okay', show_items}})
            return
        end
        
        -- Check player gold and process transaction
        if player_gold < item.cost then
            open_dialogue('Not enough gold to buy ' .. item.name .. ' (Cost: ' .. item.cost .. ')', {{'Sorry', show_items}})
        else
           -- table.remove(merchant.items, index)
            merchant.gold = merchant.gold + item.cost
            player_gold = player_gold - item.cost
            open_dialogue('You bought ' .. item.name .. ' for ' .. item.cost .. ' gold!', {{'Thanks', show_items}})
            self.spawn_bought_item(item.name)
        end
    end
  end

  function show_items()
    self.set_camera(self.owner)

    -- build the list of items (and the related callbacks)
    local items = {}
    for k,v in pairs(merchant.items) do
      -- v is the item name, k is its index (we use it as in lua we can only remove efficiently by index)
      table.insert(items, {'Buy ' .. v.name .. ' (' .. v.cost .. ' gold)', buy(k)})
    end
    table.insert(items, {'Nothing, Thanks', close})

    open_dialogue([[Welcome to my humble shop,
      You have ]] .. player_gold .. ' gold', items)
  end

  -- triggered by 'Speak' event
  show_items()
end

return merchant