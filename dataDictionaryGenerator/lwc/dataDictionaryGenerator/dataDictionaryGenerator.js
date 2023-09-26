import { LightningElement,track } from 'lwc';
import getObjects from '@salesforce/apex/DataDictionaryGeneratorController.getSObjects';
import generateCsv from '@salesforce/apex/DataDictionaryGeneratorController.generateCsv';
export default class DataDictionaryGenerator extends LightningElement {
    // value = [];
    objectNames = [];
    value = ['option1'];
    data;
    searchedObjectNames = [];
    selectedValues = [];
    newSelection = [];
    // get options() {
    //     return [
    //         { label: 'Salesforce Aura', value: 'option1' },
    //         { label: 'Salesforce LWC', value: 'option2' },
    //         { label: 'Tutorial W3web.net', value: 'option3' },
    //     ];
    // }
    connectedCallback() {
        this.getObjectsNames();
        
    }
    
    getObjectsNames(){
        getObjects().then(result => {
            //console.log("result",result);
            for(var index in result){
               // console.log(result);
                var objectDetail = result[index];
                //console.log("objectDetail",objectDetail);
                this.objectNames.push({
                    label: objectDetail.label, 
                    value: objectDetail.value
                });
            }
            
            this.objectNames = JSON.parse(JSON.stringify(this.objectNames));

            this.searchedObjectNames = [...this.objectNames];
            //console.log('OUTPUT : ',JSON.stringify(this.objectNames));
        })
        .catch(error => {
            console.log("error",error);
            //this.error = error;
            //this.isLoading = false;
        });
    }
    get selectedValues() {
        console.log("selected --",this.value);
        
        return this.selectedValues.join(',');
        
    }
    handleChange(e) {
        this.newSelection = e.detail.value;
        // this.selectedValues = [...this.selectedValues, ...newSelection];
    }
    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        
        this.selectedValues = [...this.selectedValues, ...this.newSelection];
        if (searchKey) {
            this.searchedObjectNames = this.objectNames.filter(record => {
                const valuesArray = Object.values(record);

                for (let val of valuesArray) {
                    let strVal = String(val);
                    if (strVal && strVal.toLowerCase().includes(searchKey)) {
                        return true; // Include the record if any value matches the searchKey
                    }
                }
                return false; // Exclude the record if no value matches the searchKey
            });
        } else {
            this.searchedObjectNames = this.objectNames; // Reset to the initial data when searchKey is empty
        }
    }
    downloadAsCsvFile(event){
       // console.log("selectedValues : ",this.selectedValues);
        generateCsv({selectedObject : this.selectedValues}).then(result => {
            //console.log("csv entered",result);
            let downloadElement = document.createElement('a');
            
            downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(result);
            downloadElement.target = '_self';
            downloadElement.download = 'Data Dictionary Generator.csv';
            document.body.appendChild(downloadElement);
            downloadElement.click(); 
        })
    }

}