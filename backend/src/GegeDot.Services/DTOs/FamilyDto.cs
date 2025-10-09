namespace GegeDot.Services.DTOs;

public class FamilyDto
{
    public PersonDto Person { get; set; } = null!;
    public List<PersonDto> Parents { get; set; } = new();
    public List<PersonDto> Children { get; set; } = new();
    public List<PersonDto> Siblings { get; set; } = new();
    public PersonDto? Spouse { get; set; }
    public List<PersonDto> Grandparents { get; set; } = new();
    public List<PersonDto> Grandchildren { get; set; } = new();
    
    public int TotalFamilyMembers => 1 + Parents.Count + Children.Count + Siblings.Count + 
                                   (Spouse != null ? 1 : 0) + Grandparents.Count + Grandchildren.Count;
}
