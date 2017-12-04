init("0", 1); --以当前应用 Home 键在右边初始化

function tap(x, y)
  touchDown(0, x, y);
  mSleep(50);
  touchUp(0, x, y);
end
-- 查找下一步按钮并点击
function findNextButton()
  local x, y = findColorInRegionFuzzy(0xb5dbe6, 88, 1646, 1241, 2035, 1393, 0, 0)
  if x > -1 then
    toast("找到下一步按钮")
    tap(x,y)
    return true
  end
  return false
end

function findStartButton()
  local x, y = findColorInRegionFuzzy(0xe0d3bb, 88, 1472, 1159, 1859, 1327, 0, 0)
  if x > -1 then
    toast("找到闯关按钮")
    tap(x,y)
    return true
  end
  return false
end

function findSkipButton()
  --x, y = findColor({1757, 102, 1787, 124}, 
  --"0|0|0x265aa5,13|16|0x245cb3,13|16|0x245cb3,8|17|0x1d6eba,7|18|0x258fcb,6|18|0x279ad1,5|15|0x1b73b9,5|14|0x176bb3,5|14|0x176bb3,5|14|0x176bb3,5|14|0x176bb3,2|12|0x1a65b1,11|16|0x1d5ab1",
  --90, 1, 1, 0)
  --if x > -1 then
  
  --end
  
  local x, y = findColorInRegionFuzzy(0x2db1de, 90, 1757, 103, 1789, 127, 1, 1)
  if x > -1 then
    toast("找到调过按钮x:"..x.."y:"..y)
    sysLog("找到调过按钮x:"..x.."y:"..y)
    tap(1771,115)
    return true
  end
  return false
end

function findRetry()
  x, y = findColorInRegionFuzzy(0xffffff, 90, 1410, 1386, 1476, 1439, 1, 1)
  if x > -1 then
    toast("找到重试按钮")
    tap(x,y)
    return true
  end
  return false
end


function forFind(target,sleepTime,doTimes)
  for i=0,doTimes  do
    local isFind=target
    if isFind()  then
      return true
    end  
    mSleep(sleepTime);
  end
  return false
  
end

function forFindRetryOrNext(sleepTime,doTimes)
  for i=0,doTimes  do
    local isFind=findNextButton() or  findRetry()
    if isFind  then
      return true
    end  
    mSleep(sleepTime);
  end
  return false
  
end


function enterGame()
  isFindRetryOrNext=forFindRetryOrNext(1000,10)
  if  isFindRetryOrNext then
    mSleep(1000);
    isFindStartButton=forFind(findStartButton,1000,10)
    if  isFindStartButton then
      mSleep(1000);
      isFindSkipButton=forFind(findSkipButton,1000,30)
      if  isFindSkipButton then
        mSleep(2000);
      end
    end
  end
end


function skipToBoss()
  -- 走到合适位置
  touchDown(1, 300, 1250); --ID为1的手指在 (150, 150) 按下
  mSleep(50);
  touchMove(1, 173, 1125); --移动到 (150, 400)
  mSleep(3000);
  touchUp(1, 173, 1125);   --在 (150, 400) 抬起
  
  -- 释放技能到嬴政
  touchDown(1, 1660, 1000); --ID为1的手指在 (150, 150) 按下
  mSleep(50);
  touchMove(1, 1570, 758); --移动到 (150, 400)
  mSleep(2000);
  touchUp(1, 1600, 758);   --在 (150, 400) 抬起
  
end

function mainStart(times) 
  for i=1,times do 
    toast("第"..i.."次运行开始...")
    enterGame()
    skipToBoss()
    mSleep(5000)
    -- 调过对话
    toast("调过BOSS对话！")
    findSkipButton()
    mSleep(2000)
    -- 点击自动
    toast("点击自动！")
    tap(1880,40)
    
    isFindSkipButton=forFind(findSkipButton,1000,30)
    if isFindSkipButton then
      mSleep(5000);
      tap(1024,414)
      mSleep(5000);
      toast("第"..i.."次运行结束！！！")
    end  
  end
end

--先展示一下UI
ret, results = showUI('ui.json')

--然后判断用户给出的返回值
if ret == 0 then
  --如果获取到的ret的值是0
  sysLog("用户按下了取消")
elseif ret == 1 then
  --如果获取到的ret的值是1
  sysLog("用户按下了确定")
  mainStart(results.retryTimes) 
end








