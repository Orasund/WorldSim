public Part createTile(int[] elements,String template_type)
{
  int[][] template;
  
  switch(template_type)
  {
    case "seed":
      template = seedTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    case "frame":
      template = frameTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    default:
      template = defaultTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
  }
  return evaluateTile(template);
}