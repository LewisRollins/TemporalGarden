local character = {}

function character:begin_play()
  -- ensure the TextRender content is empty
  self.flash('')
  print('Hello World')
end

function character:begin_overlap(other)
  if get_player() == other then
    print('Begin Overlap')
    self.flash('Speak with Twinblast')
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
    open_dialogue('Go to page 2?', {
      {'Yes', page2},
      {'No', close},
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
      {'Quit Game', quit},
      {'Close Dialogue', close},      
    })
  end

  --called by the 'Speak' event
  page1()
      
end

return character