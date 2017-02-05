public void registerElements()
{
  ObjectManager objectManager = GAME.getObjectManager();
  
  String[] elements = {"space","base","source","life","power"};
  for(int i = 0; i<5; i++)
    objectManager.registerPart(elements[i], evaluateElement(i));
  objectManager.registerGroup("elements",elements);
}