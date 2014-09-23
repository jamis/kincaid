require 'kincaid/map'
include Kincaid

map = Map.new "Haunted House"

map.new_page "1st Floor" do |page|
  page.rectangle "exterior", Point[-50, 0], 100, 105
  page.door :double, Point[-5, 0], width: 10
  page.door :normal, Point[-50, 80], height: 5
  page.door :normal, Point[50, 80], height: 5
  page.door :normal, Point[45, 105], width: 5

  page.window Point[-17.5, 0], width: 10
  page.window Point[7.5, 0], width: 10
  page.window Point[30, 0], width: 10
  page.window Point[50, 10], height: 10
  page.window Point[50, 40], height: 10
  page.window Point[-50, 20], height: 10
  page.window Point[-50, 40], height: 10

  #-----------------------------

  page.rectangle "foyer", Point[-20,0], 40, 40
  page.rectangle "parlor", Point[-20,40], 40, 40
  page.rectangle "servant hall", Point[-50,80], 100, 5
  page.rectangle "closet", Point[-35, 0], 15, 10
  page.rectangle "closet #2", Point[-50, 0], 15, 10
  page.rectangle "dining room", Point[-50, 10], 30, 50
  page.rectangle "catering", Point[-50, 60], 30, 20
  page.rectangle "study", Point[20, 0], 30, 30
  page.rectangle "library", Point[20, 30], 30, 30
  page.rectangle "secret", Point[20, 60], 15, 5
  page.rectangle "spare room #1", Point[20, 65], 15, 15
  page.rectangle "spare room #2", Point[35, 60], 15, 20
  page.rectangle "kitchen", Point[-20, 85], 40, 20
  page.rectangle "pantry", Point[-50, 85], 30, 20
  page.rectangle "storage", Point[20, 85], 30, 20

  page.gap Edge[Point[30, 30], Point[40, 30]]
  page.gap Edge[Point[-20, 100], Point[-20, 95]]
  page.gap Edge[Point[20, 100], Point[20, 95]]
  page.gap Edge[Point[-45, 80], Point[-40,80]]
  page.gap Edge[Point[-5,85], Point[5,85]]

  page.stairs :up, :north, Point[-20, 25], 5, 15
  page.stairs :up, :north, Point[15, 25], 5, 15
  page.stairs :down, :west, Point[40, 85], 10, 5
  page.stairs :up, :west, Point[-30, 100], 10, 5
  page.stairs :up, :east, Point[20, 100], 10, 5

  page.door :double, Point[-20, 15], height: 10
  page.door :double, Point[20, 15], height: 10
  page.door :double, Point[-5, 40], width: 10
  page.door :normal, Point[-20, 2.5], height: 5
  page.door :double, Point[-20, 45], height: 10
  page.door :normal, Point[-45, 60], width: 5
  page.door :normal, Point[25, 80], width: 5
  page.door :normal, Point[40, 80], width: 5
  page.door :normal, Point[-45, 10], width: 5
  page.door :normal, Point[-20, 70], height: 5

  #-----------------------------

  page.door :secret, Point[30, 60], width: 5
  page.stairs :up, :west, Point[20, 62.5], 10, 2.5
end

map.new_page "2nd Floor" do |page|
  page.rectangle "exterior", Point[-50, 0], 100, 105

  #-----------------------------

  page.polygon "balcony", Point[-20,0], Point[-20,40], Point[20,40], Point[20,0],
    Point[15,0], Point[15,30], Point[-15,30], Point[-15,0]
  page.rectangle "solarium", Point[-20,85], 40, 20
  page.rectangle "gallery", Point[-5,40], 10, 45
  page.rectangle "guest room #1 - sitting", Point[-30,0], 10, 20
  page.rectangle "guest room #1 - bedroom", Point[-45,0], 15, 20
  page.rectangle "guest room #2 - sitting", Point[-30,20], 10, 20
  page.rectangle "guest room #2 - bedroom", Point[-45,20], 15, 20
  page.rectangle "guest room #3 - sitting", Point[20,0], 10, 20
  page.rectangle "guest room #3 - bedroom", Point[30,0], 15, 20
  page.rectangle "guest room #4 - sitting", Point[20,20], 10, 20
  page.rectangle "guest room #4 - bedroom", Point[30,20], 15, 20
  page.rectangle "kincaid's sitting room", Point[-45,85], 25, 15
  page.rectangle "kincaid's bedroom", Point[-45,65], 20, 20
  page.rectangle "kincaid's meditation chamber", Point[-25,65], 20, 20
  page.rectangle "jeb's sitting room", Point[20,85], 25, 15
  page.rectangle "jeb's bedroom", Point[25,65], 20, 20
  page.rectangle "jeb's library", Point[5,65], 20, 20
  page.rectangle "private dining", Point[-35,40], 30, 25
  page.rectangle "private catering", Point[-45,40], 10, 25

  page.polygon "jeb's lab", Point[5,65], Point[20,65], Point[20,60],
    Point[30,60], Point[30,65], Point[45,65], Point[45,40], Point[5,40]

  page.gap Edge[Point[-5,40], Point[5,40]]
  page.gap Edge[Point[-5,45], Point[-5,55]]
  page.gap Edge[Point[25,72.5], Point[25,77.5]]

  page.stairs :down, :south, Point[-20, 25], 5, 15
  page.stairs :down, :south, Point[15, 25], 5, 15

  page.door :double, Point[-5,85], width: 10
  page.door :normal, Point[-20,5], height: 5
  page.door :normal, Point[-30,5], height: 5
  page.door :normal, Point[-20,25], height: 5
  page.door :normal, Point[-30,25], height: 5
  page.door :normal, Point[20,5], height: 5
  page.door :normal, Point[30,5], height: 5
  page.door :normal, Point[20,25], height: 5
  page.door :normal, Point[30,25], height: 5
  page.door :double, Point[-20,85], height: 10
  page.door :double, Point[20,85], height: 10
  page.door :normal, Point[-45,85], width: 5
  page.door :normal, Point[40,85], width: 5
  page.door :normal, Point[-35,45], height: 5
  page.door :normal, Point[-45,55], height: 5

  page.window Point[-15,105], width: 10
  page.window Point[5,105], width: 10

  #-----------------------------

  page.rectangle "stairwell", Point[20, 60], 10, 5

  page.door :concealed, Point[-45, 0], height: 5
  page.door :concealed, Point[-45, 20], height: 5
  page.door :concealed, Point[-45, 65], height: 5
  page.door :concealed, Point[45, 0], height: 5
  page.door :concealed, Point[45, 20], height: 5
  page.door :concealed, Point[45, 65], height: 5
  page.door :concealed, Point[-25, 72.5], height: 5
  page.door :secret, Point[10,65], width: 5

  page.stairs :down, :east, Point[20, 62.5], 10, 2.5
  page.stairs :down, :east, Point[-30, 100], 10, 5
  page.stairs :down, :west, Point[20, 100], 10, 5
  page.stairs :up, :east, Point[20, 60], 10, 2.5
end

map.to_pdf.render_file("haunted-house.pdf")
