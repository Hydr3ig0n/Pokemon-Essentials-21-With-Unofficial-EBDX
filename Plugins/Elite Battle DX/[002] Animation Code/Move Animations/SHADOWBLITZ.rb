#-------------------------------------------------------------------------------
#  SHADOWBLITZ
#-------------------------------------------------------------------------------
EliteBattle.defineMoveAnimation(:SHADOWBLITZ) do | args |
  factor = @targetSprite.zoom_x
  x1Move = @userIsPlayer ? 3 : -3
  x2Move = @userIsPlayer ? 13 : -13
  shake  = 10
  idx =  0 # counter
  dir = -1 # direction
  userOX = @userSprite.ox
  # set up animation
  fp = {}
  fp["bg"] = Sprite.new(@viewport)
  fp["bg"].bitmap = Bitmap.new(@viewport.width,@viewport.height)
  fp["bg"].bitmap.fill_rect(0,0,fp["bg"].bitmap.width,fp["bg"].bitmap.height,Settings::SHADOW_MOVES_COLOR)
  fp["bg"].opacity = 0
  # phase 1
  @vector.set(@scene.getRealVector(@userIndex, @userIsPlayer))
  16.times do
    fp["bg"].opacity += 12
    @scene.wait(1,true)
  end
  # user move
  for i in 0...50
    @userSprite.still
	@userSprite.ox += shake if i == 19
	pbSEPlay("Anim/TakeDownCharge",100) if i == 20 || i == 40
	pbSEPlay("Anim/TakeDownAttack",100) if i == 40
	# default movement
    if i.between?(0, 20)
		@userSprite.ox += x1Move
	end
	if i.between?(20,40)
		@userSprite.still
		if dir == -1 # move left 
			@userSprite.ox -= shake
		else # move right
			@userSprite.ox += shake
		end
	  idx += 1 
	  if idx == 2
		idx = 0
		dir = dir * -1
	  end
	end
	if i.between?(40,50)
		@userSprite.ox -= x2Move
    end
    @scene.wait(1,true)
  end
  # phase 2
  @vector.set(@scene.getRealVector(@targetIndex, @targetIsPlayer))
  for i in 0...8
	@userSprite.ox += x2Move/2
    @scene.wait(1,true)
  end
  @scene.wait(5,true)
  EliteBattle.playMoveAnimation(:HEADBUTT, @scene, @userIndex, @targetIndex, @hitNum, @multiHit, nil, false, true)
  16.times do
    fp["bg"].opacity -= 20
    @scene.wait(1,true)
  end
  @userSprite.ox = userOX
  pbDisposeSpriteHash(fp)
  @vector.reset if !@multiHit
end
