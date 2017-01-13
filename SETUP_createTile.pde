public Part createTile(int[] elements,String template_type)
{
  int[][] template;
  
  switch(template_type)
  {
    case "plant":
      template = plantTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    case "solid":
      template = solidTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    default:
      template = groundTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
  }
  return evaluateTile(template);
}