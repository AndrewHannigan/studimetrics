#= require jquery
#= require disable_children

describe "Enable / Disable Children", ->
  it "disables all children", ->
    loadFixtures 'enable_disable_children_fixture'
    $('#thing').disableChildren()

    expect($('#thing').find('*:disabled').length).toBe(3)

  it "enables all children", ->
    loadFixtures 'enable_disable_children'
    $('#thing').disableChildren()
    $('#thing').enableChildren()
    expect($('#thing *:disabled').length).toBe(0)
