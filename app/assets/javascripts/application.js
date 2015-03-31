// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require moment
//= require daterangepicker
//= require bootstrap-datetimepicker
//= require jquery.typing-0.2.0.min
//= require select2
//= require jquery_nested_form

$(document).ready(function() {
  $(".birthdatepicker").datetimepicker({
    pickTime: false,
    maxDate: new Date(),
    defaultDate: "1/1/1990"
  });

  $(".datepicker").datetimepicker({
    pickTime: false
  });

  $("#donation_date").datetimepicker({
    pickTime: false,
    maxDate: new Date(),
    defaultDate: new Date()
  });

  var donor_select2 = $("input[id='donation_donor_id']").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.donor.id
    },
    placeholder: "Search for donor by name",
    ajax: {
      url: "/donors",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { first_name_or_last_name_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.donor.full_name + "</div>";
    },
    formatSelection: function(result) {
      if(result.donor) {
        $.ajax({
          url: "/donors/" + result.donor.id + "/info",
          type: "GET",
          dataType: "html"
        })
        .always(function(data) {
          $("#donation_donor").html(data);
        });

        return result.donor.full_name
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var id = $(element).val();
      if(id !== "") {
          $.ajax("/donors/" + id + "/info", {
            dataType: "html"
          }).done(function(data) {
            $("#donation_donor").html(data);

            var elementText = $(element).attr("data-init-text");
            callback({"term":elementText});
          });
      }
    }
  }).data("select2");

  var volunteer_select2 = $("#volunteer_select2").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.person.id
    },
    placeholder: "Search for staff by email",
    ajax: {
      url: "/people",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { email_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.person.email + "</div>";
    },
    formatSelection: function(result) {
      if(result.person) {
        return result.person.email
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var elementText = $(element).attr("data-init-text");
      callback({"term":elementText});
    }
  }).data("select2");

  var item_select2 = $("input[id='donation_item_id']").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.item.id
    },
    placeholder: "Search for item by name",
    ajax: {
      url: "/items",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { name_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.item.identifier + "</div>";
    },
    formatSelection: function(result) {
      if(result.item) {
        return result.item.identifier
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var elementText = $(element).attr("data-init-text");
      callback({"term":elementText});
    }
  }).data("select2");

  var donationTypeChanged = function() {
    var type_val = $("#donation_type_cd").val();
    console.log(type_val);

    if(type_val == "cash") {
      $("#items").addClass("hidden");
      $(".donation_payment_details").addClass("hidden");
      $(".donation_amount").removeClass("hidden");
      $(".donation_receipt_number").removeClass("hidden");
    } else if(type_val == "kind") {
      $(".donation_amount").addClass("hidden");
      $(".donation_payment_details").addClass("hidden");
      $("#items").removeClass("hidden");
      $(".donation_receipt_number").addClass("hidden");
    } else if(type_val == "cheque" || type_val == "neft") {
      $("#items").addClass("hidden");
      $(".donation_amount").removeClass("hidden");
      $(".donation_payment_details").removeClass("hidden");
      $(".donation_receipt_number").removeClass("hidden");
    }
  }

  donationTypeChanged();

  $("body").on("change", "#donation_type_cd", function() {
    donationTypeChanged();
  });

  var filterDonors = function() {
    $.get($("#donor_search").attr("action"), $("#donor_search").serialize(), null, "script");
  }

  $(".donor-search").typing({
    stop: function (event, $elem) {
      filterDonors();
    },
    delay: 200
  });

  $(".donor-search-select").change(function() {
    filterDonors();
  });


  var filterDonations = function() {
    $.get($("#donation_search").attr("action"), $("#donation_search").serialize(), null, "script");
  }

  $(".donation-donor-search").typing({
    stop: function (event, $elem) {
      filterDonations();
    },
    delay: 200
  });

  $('#donation_search .daterangepicker').on('hide.daterangepicker', function(ev, picker) {
    filterDonations();
  });

  var filterPurchases = function() {
    $.get($("#purchase_search").attr("action"), $("#purchase_search").serialize(), null, "script");
  }

  $(".purchase-vendor-search").typing({
    stop: function (event, $elem) {
      filterPurchases();
    },
    delay: 200
  });

  $('#purchase_search .daterangepicker').on('hide.daterangepicker', function(ev, picker) {
    filterPurchases();
  });

  var filterDisbursements = function() {
    $.get($("#disbursement_search").attr("action"), $("#disbursement_search").serialize(), null, "script");
  }

  $('#disbursement_search .daterangepicker').on('hide.daterangepicker', function(ev, picker) {
    filterDisbursements();
  });

  var filterItems = function() {
    $.get($("#item_search").attr("action"), $("#item_search").serialize(), null, "script");
  }

  $(".item-name-search").typing({
    stop: function (event, $elem) {
      filterItems();
    },
    delay: 200
  });

  $("#donation-form").submit(function(evt) {
    if($("#donation_type_cd").val() !== "kind") {
      $("#items").remove();
    }
  });

  $(".daterangepicker").daterangepicker(
    {
      format: 'DD/MM/YYYY'
    },
    function(start, end, label) {

    }
  );
});
