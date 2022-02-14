function(input, output, session) {
  session$userData$total_order_view <- total_order_view$init_server("total_order_view")
  unit_test_view$init_server("unit_test_view")
  myprojects_view$init_server("myprojects_view")
}
