require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
   
       test "get new category form and create category" do
           get new_category_path
           assert_template 'categories/new'
           assert_difference 'Category.count', 1 do
               post_via_redirect categories_path, category: {name: "sports"}
        end
        assert_template 'categories/index'
        assert_match "sports", respond.body
        end
    
        test "invalid category submission results in failure" do
            get new_category_path
               assert_template 'categories/new'
               assert_difference 'Category.count' do
                   post categories_path, category: {name: " "}
        end
            assert_template 'categories/new'
            assert_select 'div.alert'
            assert_select 'h4.alert-heading'
            
        end
end