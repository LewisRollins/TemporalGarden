local character = {}

function character:begin_play()
  -- ensure the TextRender content is empty
  self.flash('')
  print('Hello World')
end

function character:begin_overlap(other)
  if get_player() == other then
    print('Begin Overlap')
    self.flash('Guide')
    current_target = self.owner
  end
end

function character:end_overlap(other)
  if get_player() == other then
    self.flash('')
    print('End Overlap')
    current_target = nil
  end
end

function character:speak()
  print('Speaking...')  

  --set camera to the character's one
  self.set_camera(self.owner)

  --close callback that will reset both camera and face
  function close()  
    close_dialogue()
    self.set_camera(get_player())  
    self.set_face(0.0)
  end
  
  function page1()
    open_dialogue([[
  Hello Traveller! Welcome to The Temporal Garden. As you can see my home has seen better days. 
  This island used to a luscious space full of green and life but unfortunately there are only 2 of us left, myself and the merchant over there. 
  I hate to rush you but the night is coming and your presence will have been noticed by the others. I'd reccomend you get gardening asap,
  here, use this gold and buy a pot from the merchant, he should have some old equipment laying around.
    ]], {
      {'Yes', page2},
      {'Bye', close},
  })
  end

  function page2()
    open_dialogue('Back to page 1?', {
      {'Yes', page1},
      {'No', close},
      {'Go to page 3, please...', page3}
    })
  end

  function page3()
    self.set_face(1.0)
    open_dialogue([[
This is the last page,
What do you want to do ?
    ]], {
      --{'Quit Game', quit},
      {'Bye', close},      
    })
  end

  --called by the 'Speak' event
  page1()
  self.spawn_bought_item('Gold')
      
end

return character