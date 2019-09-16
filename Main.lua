Main = {}
local this = Main
local Player
local pickUps = {}
local rb
local force = 5
local Dir

local GameObject = UnityEngine.GameObject
local Time = UnityEngine.Time
local Resources = UnityEngine.Resources
local Rigidbody = UnityEngine.Rigidbody
local Input = UnityEngine.Input
local Camera = UnityEngine.Camera
local Color = UnityEngine.Color
local PrimitiveType = UnityEngine.PrimitiveType

GameManager.luaStart = function()
	this:PlayerInit()
	this:CameraInit()
	this:EnviromentInit()
	this:PickUpInit()
end

GameManager.luaUpdate = function()
	this:UpdatePlayer()
	this:UpdateCamera()
	this:UpdatePickUp()
end

function Main:PlayerInit()
	Player = GameObject.CreatePrimitive(PrimitiveType.Sphere)
	Player.transform.position = Vector3(0,1,0)
	Player:AddComponent(typeof(Rigidbody))
	rb = Player:GetComponent('Rigidbody')
	Player:GetComponent("Renderer").material.color = Color(0.8, 0, 0.8, 1)
end

function Main:CameraInit()
	Dir = Vector3(0,10,-10)
	Camera.main.transform.position = Player.transform.position + Dir
	Camera.main.transform.eulerAngles = Vector3(45,0,0)
end

function Main:EnviromentInit()
	--创建地面
	local ground = GameObject.CreatePrimitive(PrimitiveType.Cube)
	ground.transform.localScale = Vector3(20,1,20)
	ground:GetComponent("Renderer").material.color = Color.gray
	--创建墙壁
	---[[
	for i=1,4 do
		local Wall = GameObject.CreatePrimitive(PrimitiveType.Cube)
		Wall.transform.position = Vector3(-10, 1, 0)
		Wall.transform.localScale = Vector3(1, 1, 20)
		Wall.transform:RotateAround(Vector3.zero,Vector3.up,(i-1)/4 * 360)
	end
	--]]
end

function Main:PickUpInit()
	--创建收集物
	for i=1,12 do
		pickUps[i] = GameObject.CreatePrimitive(PrimitiveType.Cube)
		local posX = 8 * math.cos(i/12 * 2 * math.pi)
		local posZ = 8 * math.sin(i/12 * 2 * math.pi)
		pickUps[i].transform.position = Vector3(posX,1,posZ)
		pickUps[i]:GetComponent("BoxCollider").isTrigger = true;
		pickUps[i]:GetComponent("Renderer").material.color = Color.yellow
	end
end

function Main:UpdatePlayer()
	local h = Input.GetAxis("Horizontal")
	local v = Input.GetAxis("Vertical")
	rb:AddForce(Vector3(h,0,v) * force)
end

function Main:UpdateCamera()
	Camera.main.transform.position = Player.transform.position + Dir
end

function Main:UpdatePickUp()
	for i,v in pairs(pickUps) do
		v.transform:Rotate(Vector3(30,45,60) * Time.deltaTime)
		local playerPos = Player.transform.position
		local selfPos = v.transform.position
		if Vector3.Distance(playerPos,selfPos) < 1 then
			GameObject.Destroy(v)
			pickUps[i] = nil
		end
	end
end