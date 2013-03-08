/* 
 * menuapp.js
 *
 * Builds a facebook-like mobile application.
 *
 * Author: Rémi Chaignon
 * 
 * ==========================================================================
 */


// MenuApp object
//
function MenuApp()
{
	this.screenWidth = 0;
	this.screenHeight = 0;
	this.mainWidth = 0;
	this.mainHeight = 0;
	this.ratio = 6;

	this.view = '';
	this.viewTitle = '';
	this.viewMain = '';
	this.viewStack = [];
	var that = this;

	// Initialize the MenuApp - Build the DOM and define basic behaviour
	//
	this.initialize = function(container, menuHeader, menuObject)
	{
		// Build HTML
		that.buildBase(container);
		that.buildMenuHeader(menuHeader);
		that.buildMenu(menuObject);

		// Store main view element
		that.view = $(".ma-view");
		that.viewTitle = $(".ma-view .ma-nav-title");
		that.viewMain = $(".ma-view .ma-main");
		that.navLeft = $(".ma-nav-left");

		// Back button behaviour
		that.navLeft.click(
			function()
			{
				if (that.view.hasClass("ma-view-sled"))
				{
					that.goBack();
				}
				else
				{
					that.view.addClass("ma-view-sled");
				}
			}
		);

		// Slide back behaviour
		that.viewMain.click(
			function()
			{
				if (!that.view.hasClass("ma-view-sled"))
				{
					that.view.addClass("ma-view-sled");
				}
			}
		);

		// Handle change of orientation
		$(window).bind(
			"orientationchange",
			function()
			{
				that.resize();
			}
		);

		// Adapt to screen size
		that.resize();
	};

	// Adapt the MenuApp to the screen size
	//
	this.resize = function(width, height)
	{
		that.screenWidth = ("undefined" !== typeof width) ? width : window.innerWidth;
		that.screenHeight = ("undefined" !== typeof height) ? height : window.innerHeight;
		that.mainWidth = that.screenWidth;
		that.mainHeight = that.screenHeight - 40;	// 40px = header height

		$(".ma-menu").css("width", "267px").css("height", that.screenHeight + "px");	// 267px = 320px - 53px = 42px button + 5px padding + 5px for balance + 1px border
		$(".ma-view").css("width", that.screenWidth + "px").css("height", that.screenHeight + "px").css("left", "268px");	// 268px = 320px - 52px = 42px button + 5px padding + 5px for balance
		$(".ma-main").css("height", (that.screenHeight - 40) + "px");	// 40px = header height
		$(".ma-nav-title").css("width", (that.screenWidth - 114) + "px");	// 114px = 2*5px padding + 2*42px button + 2*10px margin
	};

	// Build the necessary hierarchy for the MenuApp at the desired location
	//
	this.buildBase = function(container)
	{
		container.append(
			"<div class=\"ma-app\"><div class=\"ma-menu\"><div class=\"ma-header\"></div><div class=\"ma-main\"></div></div><div class=\"ma-view\"><div class=\"ma-header\"><div class=\"ma-nav\"><div class=\"ma-nav-button left\"><div class=\"ma-nav-left\"></div></div><!--<div class=\"ma-nav-title\"></div><div class=\"ma-nav-button right\"><div class=\"ma-nav-right\"></div></div>--></div></div><div class=\"ma-main\"></div></div></div>"
		);
	};

	// Build a custom view header - Usually the navigation part
	//
	this.buildViewHeader = function(viewHeaderHTML)
	{
		$(".ma-view .ma-header").append(viewHeaderHTML);
	};

	// Build a custom menu header - Usually the search part
	//
	this.buildMenuHeader = function(headerHTML)
	{
		$(".ma-menu .ma-header").append(headerHTML);
	};

	// Build the actual menu out of a JSON object
	//
	this.buildMenu = function(menuJSON)
	{
		var menu = $(".ma-menu .ma-main");

		// Go through sections
		if (("undefined" !== typeof menuJSON) && ("undefined" !== typeof menuJSON.sections))
		{
			for (i = 0; i < menuJSON.sections.length; i++)
			{
				// Get current section JSON object
				var sectionJSON = menuJSON.sections[i];

				// Build opening div tag of section (with optional id)
				var sectionId = ("undefined" !== typeof sectionJSON.id) ? sectionJSON.id : "";
				var section = $(document.createElement("div")).attr("id", sectionId).addClass("ma-section");

				// Add optional title
				if ("undefined" !== typeof sectionJSON.title)
				{
					var title = $(document.createElement("div")).addClass("ma-section-title").html(sectionJSON.title);

					section.append(title);
				}

				// Go through section's items
				for (j = 0; j < sectionJSON.items.length; j++)
				{
					var itemJSON = sectionJSON.items[j];

					// Build div element of item (with optional id)
					var itemId = ("undefined" !== typeof itemJSON.id) ? itemJSON.id : "";
					var item = $(document.createElement("div")).attr("id", itemId).addClass("ma-section-item").html(itemJSON.html);

					// Add data elements (use custom Zepto function dataObj)
					item.data(itemJSON.data);

					section.append(item);
				}

				// Add section to the options
				menu.append(section);
			}
		}
	};

	// Returns the width of the renderable view - Screen width
	//
	this.getMainWidth = function()
	{
		return this.mainWidth;
	};

	// Returns the height of the renderable view - Screen height minus the header
	//
	this.getMainHeight = function()
	{
		return this.mainHeight;
	};

	// Set the main view with the desired content (title and main)
	//
	this.setView = function(view)
	{
		var currentView = that.viewStack[that.viewStack.length - 1];

		// Update current view
		if ("undefined" !== typeof view)
		{
			currentView.title = ("undefined" !== typeof view.title) ? view.title : currentView.title;
			currentView.main = ("undefined" !== typeof view.main) ? view.main : currentView.main;
		}

		// Set title
		if ("undefined" !== typeof currentView.title)
		{
			that.viewTitle.html(currentView.title);
		}
		else
		{
			that.viewTitle.html("Loading");
		}

		// Set main
		if ("undefined" !== typeof currentView.main)
		{
			that.viewMain.html("Loading test.....");
		}
		else
		{
			that.viewMain.html("<div class='ma-busy'></div>");
		}
	};

	// Slide in a new view on top of the current one
	//
	this.pushView = function(view)
	{
		if ($(".ma-view").hasClass("ma-view-sled"))
		{
			that.viewStack.push(("undefined" !== typeof view) ? view : {});
			that.setView();

			if (1 < that.viewStack.length)
			{
				that.navLeft.addClass("ma-nav-back");
			}
		}
		else
		{
			// Clear view stack
			that.viewStack = [];
			that.viewStack.push(("undefined" !== typeof view) ? view : {});
			that.setView();

			// Slide the view in
			that.view.addClass("ma-view-sled");
		}
	};

	// Slide out the current view to reveal the previous one
	//
	this.popView = function()
	{
		that.viewStack.pop();
		that.setView();

		if (1 >= that.viewStack.length)
		{
			that.navLeft.removeClass("ma-nav-back");
		}
	};

	// Define the behaviour of the back button - Slide out the view or reveal menu depending on the view stack size
	//
	this.goBack = function()
	{
		// Check view stack for views to pop
		if (("undefined" !== typeof that.viewStack) && (1 < that.viewStack.length))
		{
			that.popView();
			return;
		}

		// No more view in the stack, show menu
		$(".ma-view").removeClass("ma-view-sled");
	};
}
