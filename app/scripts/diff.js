var showing_ratio = false;
var margin = {top: 10, right: 60, bottom: 100, left: 40},
    margin2 = {top: 430, right: 60, bottom: 20, left: 40},
    width = 1160 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom,
    height2 = 500 - margin2.top - margin2.bottom;

var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S %Z").parse;

var x = d3.time.scale().range([0, width]),
    y = d3.scale.linear().range([height, 0]),
    x2 = d3.time.scale().range([0, width]),
    y2 = d3.scale.linear().range([height2, 0]);

var xAxis = d3.svg.axis().scale(x).orient("bottom"),
    xAxis2 = d3.svg.axis().scale(x2).orient("bottom"),
    yAxis = d3.svg.axis().scale(y).orient("left");

var brush = d3.svg.brush().x(x2).on("brush", brushed);

var color = d3.scale.category10();

var priceLine = d3.svg.line()
  .interpolate("linear")
  .defined(function(d) { return !isNaN(d.price) && d.price > 0; })
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y(d.price); });

var contextLine = d3.svg.line()
  .interpolate("linear")
  .defined(function(d) { return !isNaN(d.price) && d.price > 0; })
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y2(d.price); });

var ratioLine = d3.svg.line()
  .interpolate("linear")
  .defined(function(d) { return !isNaN(d.ratio) && d.ratio > 0; })
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y(d.ratio); });

var svg = d3.select("body").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

svg.append("defs").append("clipPath")
  .attr("id", "clip")
  .append("rect")
  .attr("width", width)
  .attr("height", height);

var focus = svg.append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var context = svg.append("g")
  .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

d3.csv("onehour.csv", function(error, data) {
  color.domain(d3.keys(data[0]).filter(function(key) { return key !== "date"; }));

  data.forEach(function(d) {
    d.date = parseDate(d.date);
  });

  var cities = color.domain().map(function(name) {
    return {
      name: name,
      values: data.map(function(d) {
        return {date: d.date, price: +d[name]};
      })
    };
  });

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain([
    d3.min(cities, function(c) { return d3.min(c.values, function(v) { return v.price; }); }),
    d3.max(cities, function(c) { return d3.max(c.values, function(v) { return v.price; }); })
  ]);
  x2.domain(x.domain());
  y2.domain(y.domain());

  var city = focus.selectAll(".city")
      .data(cities)
    .enter().append("g")
      .attr("class", "city");

  city.append("path")
      .attr("class", "line")
      .attr("clip-path", "url(#clip)")
      .attr("d", function(d) { return priceLine(d.values); })
      .on("click", change)
      .style("stroke", function(d) { return color(d.name); });

  city.append("text")
    .datum(function(d) { return {name: d.name, value: d.values[d.values.length - 1]}; })
    .attr("transform", function(d) { return "translate(" + x(d.value.date) + "," + y(d.value.price) + ")"; })
    .attr("x", 3)
    .attr("dy", ".35em")
    .attr("class", "label")
    .attr("fill", function(d) { return color(d.name); })
    .text(function(d) { return d.name; });


  focus.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  focus.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  focus.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Price");

  context.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height2 + ")")
    .call(xAxis2);

  context.append("g")
    .attr("class", "x brush")
    .call(brush)
    .selectAll("rect")
    .attr("y", -6)
    .attr("height", height2 + 7);

  context.selectAll(".city")
      .data(cities)
    .enter().append("g")
      .attr("class", "city")
    .append("path")
      .attr("class", "line")
      .attr("d", function(d) { return contextLine(d.values); })
      .style("stroke", function(d) { return color(d.name); });


  function change(selected) {
    showing_ratio = true
    cities.forEach(function(city){
      city.values.forEach(function(d, index){
        selected_price = selected.values[index].price;
        d.ratio = city.name == selected.name ? 1 : (selected_price == 0 ? 1 : d.price / selected_price)
      });
    });

    var t0 = svg.transition().duration(750);
    t0.selectAll('.line').attr("d", function(d) {return ratioLine(d.values); });
    t0.selectAll(".label").attr("transform", transform);

    y.domain([
      d3.min(cities, function(c) { return d3.min(c.values, function(v) { return v.ratio; }); }),
      d3.max(cities, function(c) { return d3.max(c.values, function(v) { return v.ratio; }); })
    ]);

    var t1 = t0.transition();
    t1.selectAll('.line').attr("d", function(d) { return ratioLine(d.values); });
    t1.selectAll(".label").attr("transform", transform);
    t1.selectAll(".y.axis").call(yAxis);
  }

  function transform(d) {
    return "translate(" + x(d.value.date) + "," + y(d.value.ratio) + ")";
  }

});

function brushed() {
  x.domain(brush.empty() ? x2.domain() : brush.extent());
  focus.selectAll("path.line").attr("d", function(d){ return showing_ratio ? ratioLine(d.values) : priceLine(d.values) ; });
  focus.select(".x.axis").call(xAxis);
}

