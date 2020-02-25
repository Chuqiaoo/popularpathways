<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: cgong
  Date: 05/02/2020
  Time: 11:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Popular pathways</title>
    <style>
        body, html {
            position: relative;
            height: 95%;
            margin: 0;
        }

        /** Set some preferred visualization size, but cap it to the maximum screen size */
        #visualization {
            width: 100%;
            height: 90%;
            max-width: 100%;
            max-height: 100%;
        }
    </style>
</head>
<body>
<!-- Include FoamTree implementation. -->
<script src="foamtree/carrotsearch.foamtree.js"></script>
<script src="jQuery/jquery-3.4.1.min.js"></script>
<script>
    // Initialize FoamTree after the whole page loads to make sure
    // the element has been laid out and has non-zero dimensions.
    window.addEventListener("load", function () {
        var foamtree = new CarrotSearchFoamTree({
            // Identifier of the HTML element defined above
            id: "visualization",
            //pixelRatio: window.devicePixelRatio || 1,
           stacking: "flattened",

            //The duration of the group exposure and unexposure animation.
            exposeDuration: 500,

            // Lower groupMinDiameter to fit as many groups as possible
            groupMinDiameter: 0,

            // Set a simple fading animation. Animated rollouts are very expensive for large hierarchies
            rolloutDuration: 0,
            pullbackDuration: 0,

            // Lower the border radius a bit to fit more groups
            groupBorderWidth: 2,
            groupInsetWidth: 3,
            groupBorderRadius:0,

            // Don't use gradients and rounded corners for faster rendering
            groupFillType: "plain",

            // Lower the minimum label font size a bit to show more labels
            groupLabelMinFontSize: 3,

            //Attach and draw a maximum of 12 levels of groups
            maxGroupLevelsAttached: 12,
            maxGroupLevelsDrawn: 12,
            maxGroupLabelLevelsDrawn: 12,

            //Tune the border options to make them more visible
            groupBorderWidthScaling: 0.5,

            // Width of the selection outline to draw around selected groups
            groupSelectionOutlineWidth: 3,

            // Show labels during relaxation
            wireframeLabelDrawing: "always",

            // Make the description group (in flattened view) smaller to make more space for child groups
            descriptionGroupMaxHeight: 0.25,

            // Maximum duration of a complete high-quality redraw of the visualization
            finalCompleteDrawMaxDuration: 40000,
            finalIncrementalDrawMaxDuration: 40000,
            wireframeDrawMaxDuration: 4000,

            // Color of the outline stroke for the selected groups
            groupSelectionOutlineColor: "#E86365"
        });

        // add hits value to label
        foamtree.set({
            groupLabelDecorator: function (opts, props, vars) {
                vars.labelText = vars.labelText + " [" + props.group.age + " " + props.group.weight + "]";
            }
        });

        foamtree.set({
            groupColorDecorator: function (opts, props, vars) {
                vars.labelColor = "#000";

                var age = props.group.age;
                switch (true) {
                    case age === 0:
                        vars.groupColor = "#DDA0DD";
                        break;
                    case age >= 1 && age < 10:
                        vars.groupColor = "#BA55D3";
                        break;
                    case age >= 10 && age < 15:
                        vars.groupColor = "#9400D3";
                        break;
                    case age >= 15 && age < 20:
                        vars.groupColor = "#8B008B";
                        break;
                    default:
                        vars.groupColor = "#58C3E5";
                }
            }
        });

        // load data
        foamtree.set({
            dataObject: {
                groups: ${data}
            }
        });

        window.addEventListener("resize", (function () {
            var timeout;
            return function () {
                window.clearTimeout(timeout);
                timeout = window.setTimeout(foamtree.resize, 300);
            };
        })());
    });

</script>
<div id="visualization"></div>
<h4>${file}</h4>
<h3>Year: ${year}</h3>

<h3 style="color:red">${fileSuccess}</h3>

<h2><a href="${pageContext.request.contextPath}/upload">click to upload</a></h2>

</body>
</html>
